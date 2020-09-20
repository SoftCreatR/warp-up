FROM bitnami/minideb:latest
LABEL maintainer="Sascha Greuel <hello@1-2.dev>"

ENV DEBIAN_FRONTEND noninteractive

RUN install_packages \
    bash \
    ca-certificates \
    curl && \
 apt-get clean -y && \
 rm -rf /tmp/* /var/tmp/* /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN curl -sL 1-2.dev/warp-up -o /root/warp-up.sh && \
    chmod +x /root/warp-up.sh

ENTRYPOINT ["/root/warp-up.sh"]
