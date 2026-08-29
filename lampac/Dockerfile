ARG LAMPAC_VERSION=1.50.1
FROM ghcr.io/lampac-nextgen/lampac:${LAMPAC_VERSION}

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    jq \
    nginx \
    && rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/sites-available/default
COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
