FROM debian:bullseye-slim

ARG TARGETPLATFORM
SHELL ["/bin/bash", "-c"]

# Hack because we can't do substitutions in ARG / COPY
COPY ./artifacts/* /tmp
RUN addgroup --gid 1000 user \
  && adduser --disabled-password --gecos '' --uid 1000 --gid 1000 user \
  && ls -al /tmp/ \
  && cp /tmp/${TARGETPLATFORM//\//-}/nimbus_beacon_node /home/user/nimbus_beacon_node \
  && rm -r /tmp/*

USER user
STOPSIGNAL SIGINT

WORKDIR /home/user
ENTRYPOINT /home/user/nimbus_beacon_node
