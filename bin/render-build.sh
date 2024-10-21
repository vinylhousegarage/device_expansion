#!/usr/bin/env bash
set -o errexit

export NODE_ENV=production
export SECRET_KEY_BASE=${SECRET_KEY_BASE}

echo "Installing Ruby gems..."
bundle install --without development test || { echo "Bundle install failed"; exit 1; }

echo "Installing importmap..."
bin/rails importmap:install

echo "Building assets..."
yarn build

echo "Preparing public/assets directory..."
mkdir -p public/assets
cp -r app/assets/builds/* public/assets/

echo "Precompiling assets..."
bundle exec rails assets:precompile

echo "Running database migrations..."
bundle exec rails db:migrate

echo "Seeding the database..."
bundle exec rails db:seed
