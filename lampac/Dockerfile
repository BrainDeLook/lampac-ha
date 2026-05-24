FROM ghcr.io/lampac-nextgen/lampac:latest

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    jq \
    nginx \
    && rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/sites-available/default
COPY run.sh /run.sh
COPY enable_adminpanel.sh /enable_adminpanel.sh
RUN chmod +x /run.sh /enable_adminpanel.sh

ENTRYPOINT ["/run.sh"]
