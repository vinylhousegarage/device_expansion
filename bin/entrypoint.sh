#!/usr/bin/env bash
set -o errexit

if [ -f tmp/pids/server.pid ]; then
  echo "Removing old PID file..."
  rm -f tmp/pids/server.pid
fi

if [ "$RAILS_ENV" == "development" ]; then
  echo "Running database creation..."
  bundle exec rails db:create || echo "Database already exists, skipping creation."

  echo "Running database migrations..."
  bundle exec rails db:migrate

  echo "Seeding the database..."
  bundle exec rails db:seed:replant

  echo "Starting Puma server for development..."
  exec bundle exec puma -C config/puma.rb
else
  echo "Starting Puma server for production..."
  exec "$@"
fi
