SHELL := /bin/sh

# Configurable variables
IMAGE ?= sam-jekyll
CONTAINER ?= sam-jekyll-dev
SITE_PORT ?= 4000
LIVERELOAD_PORT ?= 35729

.PHONY: dev build stop

build:
	@docker build -t $(IMAGE) .

dev: build
	@echo "Starting Jekyll dev server on http://localhost:$(SITE_PORT) (livereload: $(LIVERELOAD_PORT))"
	@docker run --rm -it \
		--name $(CONTAINER) \
		-p $(SITE_PORT):4000 \
		-p $(LIVERELOAD_PORT):35729 \
		-v "$(PWD)":/site \
		$(IMAGE)

stop:
	@docker rm -f $(CONTAINER) 2>/dev/null || true

