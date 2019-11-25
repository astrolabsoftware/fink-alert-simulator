# Fink alert simulator

`fink-alert-simulator` is a package to inject alert data to Apache Kafka to feed brokers listening to Kafka streams. The main purposes are testing the broker and replaying historical alert data. This package belongs to the [fink broker](https://github.com/astrolabsoftware/fink-broker) ecosystem.

## Installation

Fork and/or clone the repo, and update your PYTHONPATH and PATH to use the tools:

```bash
# in your ~/.bash_profile
export FINK_ALERT_SIMULATOR=/path/to/fink-alert-simulator
export PYTHONPATH=$FINK_ALERT_SIMULATOR:$PYTHONPATH
export PATH=$FINK_ALERT_SIMULATOR/bin:$PATH
```

## Usage

Learn how to use fink-alert-simulator by following the dedicated tutorial (TBD).
