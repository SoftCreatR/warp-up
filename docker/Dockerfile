FROM bitnami/minideb:latest
MAINTAINER Sascha Greuel <hello@1-2.dev>

# Disable prompts from apt.
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y &&\
 apt-get install -y --no-install-recommends \
    git \
    curl \
    bash \
    ca-certificates \
    ncurses-bin && \
 apt-get autoremove -y && \
 apt-get clean -y && \
 rm -rf /tmp/* /var/tmp/* /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN git clone https://github.com/SoftCreatR/warp-up.git /root/warp-up

RUN apt-get remove git -y

WORKDIR /root/warp-up/

ENTRYPOINT ["/bin/bash", "warp-up.sh", "--id $REFERRER", "--iterations $ITERATIONS", "--interval $INTERVAL", "--log-file $LOG_FILE", "--disclaimer"]
