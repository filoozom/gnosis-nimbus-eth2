FROM debian:bullseye-slim

ARG TARGETPLATFORM

RUN addgroup --gid 1000 user \
  && adduser --disabled-password --gecos '' --uid 1000 --gid 1000 user

USER user
STOPSIGNAL SIGINT

COPY $TARGETPLATFORM/nimbus_beacon_node /home/user/nimbus_beacon_node

WORKDIR /home/user
ENTRYPOINT /home/user/nimbus_beacon_node
