FROM docker.io/debian:bullseye-slim

ARG PBS_CLIENT_VERSION=2.4.1-1

RUN set -exu \
  && wget https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg \
    -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg \
  && echo "deb http://download.proxmox.com/debian/pbs-client bullseye main" > /etc/apt/sources.list.d/pbs-client.list \
  && DPKG_FRONTEND=noninteractive apt-get -yq update \
  && DPKG_FRONTEND=noninteractive apt-get -yq dist-upgrade \
  && DPKG_FRONTEND=noninteractive apt-get -yq install \
    proxmox-backup-client=${PBS_CLIENT_VERSION} \
    cron \
  && mkdir -p \
    /opt/jellypb/logs \
    /opt/jellypb/backup \
  && rm -rf \
    /etc/cron.d \
    /etc/cron.daily \
    /etc/cron.hourly \
    /etc/cron.monthly \
    /etc/crontab \
    /etc/cron.weekly

ENV \
  DEBUG=false \
  ENVDEBUG=false \
  PBS_REPOSITORY=false \
  PBS_PASSWORD=false \
  CRON=false \
  ONESHOT=false \
  BACKUP_NAME="backup" \
  REPORT_EMAIL_FROM="root@localhost" \
  REPORT_EMAIL_TO="root@localhost" \
  REPORT_EMAIL_FORMAT="plain"

COPY backup.sh /opt/jellypb/backup.sh
COPY entrypoint.sh /opt/jellypb/entrypoint.sh
COPY report.sh /opt/jellypb/report.sh

CMD ["/usr/bin/bash", "/opt/jellypb/entrypoint.sh"]
