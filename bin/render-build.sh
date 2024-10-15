#!/usr/bin/env bash
set -o errexit

bundle install
yarn install
yarn add esbuild
yarn build
bundle exec rails assets:precompile
bundle exec rails db:migrate
