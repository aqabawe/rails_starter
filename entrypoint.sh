#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /poc/tmp/pids/server.pid

# Check if there's any missing gems
if [ -f Gemfile ]; then
  echo -n "Checking bundle... "
  if $(bundle check &> /dev/null); then
    echo "all good 👌"
  else
    echo "Something is missing 💥"
    echo "Updating bundle now…"
    BUNDLE_CLEAN=true bundle install --jobs 20 --retry 5
  fi
else
  echo "No Gemfile found. Skipping Ruby dependencies check."
fi
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
