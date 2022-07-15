FROM alpine:3.16

# Install necessary system packages
RUN apk add --no-cache bash git python3 tini

# Set up python
ENV PYTHONUNBUFFERED=1

# Set script defaults
ENV LC2AG_DOMAINS_REPO="https://github.com/uklans/cache-domains.git"
ENV LC2AG_CACHE_SERVER="lancache.local"
ENV LC2AG_TEMP_DIR="/lc2ag/temp"
ENV LC2AG_OUT_FILE="/lc2ag/domains.txt"

WORKDIR /lc2ag

# Add scripts and set permissions 
COPY create_list.sh ./
COPY init.sh ./
RUN chmod +x ./create_list.sh ./init.sh

# Add cron file and set permissions
COPY update_list.cron /etc/cron.d/lc2ag
RUN chmod 0644 /etc/cron.d/lc2ag
RUN crontab /etc/cron.d/lc2ag

EXPOSE 8080

ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "./init.sh" ]


