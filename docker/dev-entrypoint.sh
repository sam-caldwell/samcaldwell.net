#!/usr/bin/env bash
set -euo pipefail

cd /site

# Ensure bundler installs to a known path and loads plugin group
bundle config set path /usr/local/bundle >/dev/null
bundle config set with "jekyll_plugins" >/dev/null

echo "Installing gems (this may take a moment)..."
bundle install --jobs 4 --retry 3

echo "Starting Jekyll via bundle exec..."
exec bundle exec jekyll serve \
  --livereload \
  --force_polling \
  --host 0.0.0.0 \
  --port 4000 \
  --livereload-port 35729 \
  --source /site \
  --destination /srv/_site \
  --trace

