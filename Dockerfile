FROM ubuntu:24.04

# System deps, Ruby, Bundler, and native libraries for gems (nokogiri, ffi, etc.)
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y \
  && apt-get install -y --no-install-recommends \
     ca-certificates \
     git \
     build-essential \
     ruby-full ruby-dev ruby-bundler \
     libffi-dev libxml2-dev libxslt1-dev zlib1g-dev \
     pkg-config \
  && rm -rf /var/lib/apt/lists/* \
  && gem install --no-document jekyll -v "~> 4.3" \
  && gem install --no-document webrick jekyll-seo-tag jekyll-sitemap

WORKDIR /site

# Optional: preinstall bundle if Gemfile is provided (cached layer)
COPY Gemfile* /site/
RUN if [ -f Gemfile ]; then \
      bundle config set path /usr/local/bundle && \
      bundle config set with "jekyll_plugins" && \
      bundle install --jobs 4 --retry 3 || true; \
    fi \
    && mkdir -p /srv/_site /srv/.jekyll-cache

EXPOSE 4000 35729
ENV JEKYLL_ENV=development \
    JEKYLL_CACHE_DIR=/srv/.jekyll-cache

# Serve with livereload, watching the mounted /site
CMD [ \
  "jekyll", "serve", \
  "--livereload", \
  "--force_polling", \
  "--host", "0.0.0.0", \
  "--port", "4000", \
  "--livereload-port", "35729", \
  "--source", "/site", \
  "--destination", "/srv/_site", \
  "--trace" \
]
