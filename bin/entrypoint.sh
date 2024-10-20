#!/usr/bin/env bash
set -o errexit  # エラーが発生したら即座に終了

echo "Running database creation..."
bundle exec rails db:create RAILS_ENV=development || echo "Database already exists, skipping creation."

echo "Running database migrations..."
bundle exec rails db:migrate

echo "Seeding the database..."
bundle exec rails db:seed

echo "Starting Puma server..."
exec bundle exec puma -C config/puma.rb
