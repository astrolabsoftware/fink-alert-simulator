#!/usr/bin/env python
# Copyright 2019-2022 AstroLab Software
# Author: Julien Peloton
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""Simulate batches of alerts coming from ZTF or ELaSTICC.
"""
import argparse
import os
import sys
import glob
import time
import asyncio
import gzip

import numpy as np

from fink_alert_simulator import alertProducer
from fink_alert_simulator import avroUtils

from fink_alert_simulator.parser import getargs

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    args = getargs(parser)

    # Configure producer connection to Kafka broker
    conf = {'bootstrap.servers': args.servers}
    streamproducer = alertProducer.AlertProducer(
        args.topic, schema_files=None, **conf)

    # Scan for avro files
    root = args.datasimpath

    # Grab data stored on disk
    files = glob.glob(os.path.join(root, "*.avro*"))

    # Number of observations, and total number of alerts to send.
    nobs = args.nobservations
    poolsize = args.nalerts_per_obs * nobs

    if nobs == -1:
        # Take all alerts available
        nobs = int(len(files) / float(args.nalerts_per_obs)) + 1
        poolsize = args.nalerts_per_obs * nobs
        msg = """
        All {} alerts to be sent (nobservations=-1), corresponding
        to {} observations ({} alerts each).
        """.format(len(files), nobs, args.nalerts_per_obs)
        print(msg)
    elif len(files) < poolsize:
        # Send only available alerts
        nobs = int(len(files) / float(args.nalerts_per_obs)) + 1
        msg = """
        You ask for more data than you have!
        Number of alerts on disk ({}): {}
        Number of alerts required (nalerts_per_obs * nobservations): {}

        Hence, we reduced the number of observations to {}.
        """.format(root, len(files), poolsize, nobs)
        print(msg)

    print('Total alert available ({}): {}'.format(root, len(files)))
    print('Total alert to be sent: {}'.format(poolsize))

    # Break the alert list into observations
    files = np.array_split(files[:poolsize], nobs)[:nobs]

    # Starting time
    t0 = time.time()
    print("t0: {}".format(t0))

    def send_visit(list_of_files):
        """ Send all alerts of an observation for publication in Kafka

        Parameters
        ----------
        list_of_files: list of str
            List with filenames containing the alert (avro file). Alerts
            can be gzipped, but the extension should be
            explicit (`avro` or `avro.gz`).
        """
        print('Observation start: t0 + : {:.2f} seconds'.format(
            time.time() - t0))
        # Load alert contents
        startstop = []
        for index, fn in enumerate(list_of_files):
            if fn.endswith('avro'):
                copen = lambda x: open(x, mode='rb')
            elif fn.endswith('avro.gz'):
                copen = lambda x: gzip.open(x, mode='rb')
            else:
                msg = """
                Alert filename should end with `avro` or `avro.gz`.
                Currently trying to read: {}
                """.format(fn)
                raise NotImplementedError(msg)

            with copen(fn, mode='rb') as file_data:
                # Read the data
                data = avroUtils.readschemadata(file_data)

                # Read the Schema
                schema = data.schema

                # assuming one record per data
                record = data.next()
                if index == 0 or index == len(list_of_files) - 1:
                    if args.to_display != 'None':
                        startstop.append(record[args.to_display])
                streamproducer.send(record, alert_schema=schema, encode=True)

        if args.to_display != 'None':
            print('{} alerts sent ({} to {})'.format(len(
                list_of_files),
                startstop[0],
                startstop[1]))

        # Trigger the producer
        streamproducer.flush()

    loop = asyncio.get_event_loop()
    asyncio.ensure_future(
        alertProducer.schedule_delays(
            loop,
            send_visit,
            files,
            interval=args.tinterval_kafka))
    loop.run_forever()
    loop.close()


if __name__ == "__main__":
    main()
