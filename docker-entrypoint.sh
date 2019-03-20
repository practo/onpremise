#!/usr/bin/env bash
set -e

if [[ -z ${run_migration} ]]; then
  if [[ -z ${worker_cmd} ]]; then
    sentry run web
  else
    mkdir -p "$SENTRY_FILESTORE_DIR"
	  chown -R sentry "$SENTRY_FILESTORE_DIR"
	  eval ${worker_cmd}
  fi
else
  # Loads initial schema if doesn't already exists
  sentry exec initialize.py
  # Load fixtures
  sentry exec sync_fixtures.py
fi
