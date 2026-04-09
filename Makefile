SHELL := /bin/sh

# Configurable variables
IMAGE ?= sam-jekyll
CONTAINER ?= sam-jekyll-dev
SITE_PORT ?= 4000
LIVERELOAD_PORT ?= 35729
# Bind published ports to this host address (default: loopback only)
BIND_ADDRESS ?= 127.0.0.1

.PHONY: dev build stop post joke epitaph book

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
# Usage: make post TITLE="Your Post Title"
post:
	@TITLE="$(TITLE)"; \
	if [ -z "$$TITLE" ]; then \
	  printf "Title: "; read -r TITLE; \
	fi; \
	if [ -z "$$TITLE" ]; then \
	  echo "Error: TITLE is required. Use: make post TITLE='My Title'"; \
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

# Create a new joke page under jokes/
# Usage: make joke TITLE="A Funny Joke"
joke:
	@TITLE="$(TITLE)"; \
	if [ -z "$$TITLE" ]; then \
	  printf "Title: "; read -r TITLE; \
	fi; \
	if [ -z "$$TITLE" ]; then \
	  echo "Error: TITLE is required. Use: make joke TITLE='My Joke'"; \
	  exit 1; \
	fi; \
	SLUG=$$(printf "%s" "$$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$$//g'); \
	DATE=$$(date +%Y-%m-%d); \
	TIME=$$(date +%H:%M:%S%z); \
	FILE="jokes/$${SLUG}.html"; \
	mkdir -p jokes; \
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
	  echo '---'; \
	  echo; \
	  echo '<!-- Write your joke below. -->'; \
	} > "$$FILE"; \
	echo "Created $$FILE"

# Create a new epitaph page under epitaphs/
# Usage: make epitaph TITLE="An Epitaph"
epitaph:
	@TITLE="$(TITLE)"; \
	if [ -z "$$TITLE" ]; then \
	  printf "Title: "; read -r TITLE; \
	fi; \
	if [ -z "$$TITLE" ]; then \
	  echo "Error: TITLE is required. Use: make epitaph TITLE='My Epitaph'"; \
	  exit 1; \
	fi; \
	SLUG=$$(printf "%s" "$$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$$//g'); \
	DATE=$$(date +%Y-%m-%d); \
	TIME=$$(date +%H:%M:%S%z); \
	FILE="epitaphs/$${SLUG}.html"; \
	mkdir -p epitaphs; \
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
	  echo '---'; \
	  echo; \
	  echo '<!-- Write your epitaph below. -->'; \
	} > "$$FILE"; \
	echo "Created $$FILE"

# Create a new book page under books/
# Usage: make book TITLE="Book Title"
book:
	@TITLE="$(TITLE)"; \
	if [ -z "$$TITLE" ]; then \
	  printf "Title: "; read -r TITLE; \
	fi; \
	if [ -z "$$TITLE" ]; then \
	  echo "Error: TITLE is required. Use: make book TITLE='My Book'"; \
	  exit 1; \
	fi; \
	SLUG=$$(printf "%s" "$$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$$//g'); \
	DATE=$$(date +%Y-%m-%d); \
	TIME=$$(date +%H:%M:%S%z); \
	FILE="books/$${SLUG}.html"; \
	mkdir -p books; \
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
	  echo '---'; \
	  echo; \
	  echo '<!-- Write your book notes below. -->'; \
	} > "$$FILE"; \
	echo "Created $$FILE"
