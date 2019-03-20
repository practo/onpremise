#!/usr/bin/env bash
set +e

if [[ -z ${run_migration} ]]; then
  # Loads initial schema if doesn't already exists
  sentry exec initialize.py
  # Runs sentry migrations
  sentry upgrade
  # Load fixtures
  sentry exec sync_fixtures.py
elif [[ -z ${worker_cmd} ]]; then
  sentry run web
else
  eval ${worker_cmd}
fi
