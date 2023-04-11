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

ONESHOT="${ONESHOT:-false}"
CRON="${CRON:-false}"

if [[ ! "${ONESHOT}" ]] && [[ ! "${CRON}" ]]; then
  echo "Neither cron or oneshot enabled, exiting"
  exit 1
fi

if $ONESHOT; then
  # run oneshot
  echo "Oneshot enabled, starting backup"
  . /backup.sh
fi

if $CRON; then
  # start crond
  echo "Cron mode enabled, starting cron"
  /usr/sbin/cron -f -n -L 15
fi

exit 0
