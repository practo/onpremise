#!/usr/bin/env bash
set -e

cp /usr/src/sentry/env /usr/src/sentry/.env

if [[ -z ${run_migration} ]]; then
  if [[ -z ${worker_cmd} ]]; then
    sentry run web
  else
    eval ${worker_cmd}
  fi
else
  # Loads initial schema if doesn't already exists
  sentry exec initialize.py
  # Load fixtures
  sentry exec sync_fixtures.py
fi
