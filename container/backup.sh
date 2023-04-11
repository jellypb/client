#!/usr/bin/env bash

# debug mode = set -x = loud
DEBUG="${DEBUG:-false}"
if $DEBUG; then
  set -exu
else
  set -eu
fi

# if debug, print envvars
ENVDEBUG="${ENVDEBUG:-false}"
if $ENVDEBUG; then
  env
fi

# where this .sh file lives
DIRNAME=$(dirname "$0")
SCRIPT_DIR=$(cd "$DIRNAME" || exit 1; pwd)
cd "$SCRIPT_DIR" || exit 1

if [[ ! "${PBS_REPOSITORY}" ]] || [[ ! "${PBS_PASSWORD}" ]]; then
  echo "You need to set PBS_REPOSITORY or PBS_PASSWORD envvar!"
  exit 1
fi

# run the backup
/usr/bin/proxmox-backup-client \
  backup \
  "${BACKUP_NAME}.pxar:/opt/jellypb/backup" \
    | tee /opt/jellypb/logs/latest.log

BACKUP_EXITCODE=$?

if $REPORT; then
  echo "Reporting enabled, sending report to ${REPORT_EMAIL_TO}"
  . /report.sh "${BACKUP_EXITCODE}"
fi
