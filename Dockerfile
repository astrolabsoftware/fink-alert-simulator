FROM python:3.10.2-bullseye as fink-alert-simulator-deps
LABEL org.opencontainers.image.authors="fabrice.jammes@in2p3.fr"

RUN pip3 install --upgrade pip==22.3

RUN useradd --create-home --uid 1000 --shell /bin/bash fink
USER fink


ENV FINK_ALERT_SIMULATOR=/fink
ENV PATH /home/fink/.local/bin:$FINK_ALERT_SIMULATOR/bin:$PATH
ENV PYTHONPATH=$FINK_ALERT_SIMULATOR:$PYTHONPATH

COPY rootfs/fink/requirements.txt $FINK_ALERT_SIMULATOR/

RUN python3 -m pip install -r /fink/requirements.txt

FROM fink-alert-simulator-deps

COPY rootfs/ /
