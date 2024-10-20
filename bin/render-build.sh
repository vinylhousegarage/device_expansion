#!/usr/bin/env bash
set -o errexit

export NODE_ENV=production

echo "Building assets..."
yarn build:production

echo "Precompiling assets..."
bundle exec rails assets:precompile

echo "Running database migrations..."
bundle exec rails db:migrate

echo "Seeding the database..."
bundle exec rails db:seed
