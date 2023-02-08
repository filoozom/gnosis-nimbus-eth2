FROM debian:bullseye-slim as builder

ARG UPSTREAM_VERSION

ENV DEBIAN_FRONTEND=noninteractive TZ="Etc/UTC"
RUN apt update \
  && apt install -y build-essential git \
  && git clone --depth 1 --branch $UPSTREAM_VERSION https://github.com/status-im/nimbus-eth2.git \
  && cd nimbus-eth2  \
  && make -j$(nproc) update  \
  && make -j$(nproc) LOG_LEVEL=TRACE NIMFLAGS="${NIMFLAGS_COMMON}" PARTIAL_STATIC_LINKING=1 QUICK_AND_DIRTY_COMPILER=1 gnosis-chain-build

FROM debian:bullseye-slim

RUN addgroup --gid 1000 user \
  && adduser --disabled-password --gecos '' --uid 1000 --gid 1000 user;

USER user
STOPSIGNAL SIGINT

COPY --from=builder ./nimbus-eth2/build/nimbus_beacon_node_gnosis /home/user/nimbus_beacon_node
WORKDIR /home/user

ENTRYPOINT /home/user/nimbus_beacon_node
