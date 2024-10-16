#!/usr/bin/env bash
set -o errexit

echo "Running bundle install..."
bundle install

echo "Running yarn install..."
yarn install

echo "Adding esbuild..."
yarn add esbuild

echo "Building assets..."
yarn build

echo "Precompiling assets..."
bundle exec rails assets:precompile

echo "Running database migrations..."
bundle exec rails db:migrate

echo "Seeding the database..."
bundle exec rails db:seed
