#!/usr/bin/env bash

# Exit on error
set -o errexit

# Install dependencies
bundle install

# Precompile assets
bin/rails assets:precompile
bin/rails assets:clean

# For free tier, keep migrations in the build phase
bin/rails db:migrate