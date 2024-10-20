#!/usr/bin/env bash
set -o errexit

export NODE_ENV=production
export SECRET_KEY_BASE=${SECRET_KEY_BASE}

echo "Installing importmap..."
bin/rails importmap:install

echo "Building assets..."
yarn build

echo "Precompiling assets..."
bundle exec rails assets:precompile

echo "Running database migrations..."
bundle exec rails db:migrate

echo "Seeding the database..."
bundle exec rails db:seed
