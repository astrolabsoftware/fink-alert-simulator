# Copyright 2019 AstroLab Software
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
from fink_alert_simulator.tester import regular_unit_tests
import argparse

def getargs(parser: argparse.ArgumentParser) -> argparse.Namespace:
    """ Parse command line arguments for fink alert simulator service

    Parameters
    ----------
    parser: argparse.ArgumentParser
        Empty parser

    Returns
    ----------
    args: argparse.Namespace
        Object containing CLI arguments parsed

    Examples
    ----------
    >>> import argparse
    >>> parser = argparse.ArgumentParser(description=__doc__)
    >>> args = getargs(parser)
    >>> print(type(args))
    <class 'argparse.Namespace'>
    """
    parser.add_argument(
        '-servers', type=str, default='',
        help="""
        Hostname or IP and port of Kafka broker producing stream.
        [KAFKA_IPPORT/KAFKA_IPPORT_SIM]
        """)
    parser.add_argument(
        '-topic', type=str, default='',
        help="""
        Name of Kafka topic stream to read from.
        [KAFKA_TOPIC/KAFKA_TOPIC_SIM]
        """)
    parser.add_argument(
        '-tinterval_kafka', type=float, default=0.0,
        help="""
        Time interval between two messages are published. In seconds.
        [TIME_INTERVAL]
        """)
    parser.add_argument(
        '-datasimpath', type=str, default='',
        help="""
        Folder containing simulated alerts to be published by Kafka.
        [FINK_DATA_SIM]
        """)
    parser.add_argument(
        '-poolsize', type=int, default=5,
        help="""
        Maximum number of alerts to send. If the poolsize is
        bigger than the number of alerts in `datapath`, then we replicate
        the alerts. Default is 5.
        [POOLSIZE]
        """)
    args = parser.parse_args(None)
    return args


if __name__ == "__main__":
    """ Execute the test suite """

    # Run the regular test suite
    regular_unit_tests(globals())
