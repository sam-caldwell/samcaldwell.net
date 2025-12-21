SHELL := /bin/sh

# Configurable variables
IMAGE ?= sam-jekyll
CONTAINER ?= sam-jekyll-dev
SITE_PORT ?= 4000
LIVERELOAD_PORT ?= 35729
# Bind published ports to this host address (default: loopback only)
BIND_ADDRESS ?= 127.0.0.1

.PHONY: dev build stop new

build:
	@docker build -t $(IMAGE) .

dev: build
	@echo "Starting Jekyll dev server on http://localhost:$(SITE_PORT) (livereload: $(LIVERELOAD_PORT))"
	@echo "Binding ports to $(BIND_ADDRESS)"
	@docker run --rm -it \
		--name $(CONTAINER) \
		-p $(BIND_ADDRESS):$(SITE_PORT):4000 \
		-p $(BIND_ADDRESS):$(LIVERELOAD_PORT):35729 \
		-v "$(PWD)":/site \
		$(IMAGE)

stop:
	@docker rm -f $(CONTAINER) 2>/dev/null || true

# Create a new blog post
# Usage: make new TITLE="Your Post Title"
new:
	@TITLE="$(TITLE)"; \
	if [ -z "$$TITLE" ]; then \
	  printf "Title: "; read -r TITLE; \
	fi; \
	if [ -z "$$TITLE" ]; then \
	  echo "Error: TITLE is required. Use: make new TITLE='My Title'"; \
	  exit 1; \
	fi; \
	SLUG=$$(printf "%s" "$$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$$//g'); \
	DATE=$$(date +%Y-%m-%d); \
	TIME=$$(date +%H:%M:%S%z); \
	FILE="_posts/$${DATE}-$${SLUG}.md"; \
	mkdir -p _posts; \
	if [ -e "$$FILE" ]; then \
	  echo "Error: $$FILE already exists"; \
	  exit 1; \
	fi; \
	{ \
	  echo '---'; \
	  echo 'layout: page'; \
	  printf 'title: %s\n' "$$TITLE"; \
	  printf 'date: %s %s\n' "$$DATE" "$$TIME"; \
	  echo 'description:'; \
	  echo 'tags: []'; \
	  echo '---'; \
	  echo; \
	  echo '<!-- Write your post below. -->'; \
	} > "$$FILE"; \
	echo "Created $$FILE"
