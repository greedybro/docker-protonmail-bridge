FROM debian:buster-slim

ENV LANG C.UTF-8

RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            ca-certificates \
            unzip \
            socat \
            pass \
            gnupg \
            grep \
            curl \
            libcap2-bin

# install protonmail bridge

RUN set -x; \
        curl -o bridge.deb -SL https://protonmail.com/download/protonmail-bridge_1.3.3-1_amd64.deb \
        && dpkg --force-depends -i bridge.deb \
        && apt-get update \
        && apt-get -y install -f --no-install-recommends \
        && rm -rf /var/lib/apt/lists/* bridge.deb

RUN useradd -ms /bin/bash proton
COPY gpgparams /
COPY init_protonmail.sh /bin
RUN chmod +x /bin/init_protonmail.sh
RUN rm -rf /tmp
RUN setcap 'cap_net_bind_service=+ep' /usr/bin/socat
USER proton
WORKDIR /home/proton

ENTRYPOINT /bin/init_protonmail.sh
