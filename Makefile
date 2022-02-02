# Makefile

APP_ID := $(APP_ID)
IMAGE_NAME := app-token-generator
REGISTRY_URL := quay.io
REGISTRY_USERNAME := techprober
REGISTRY_PASSWORD := $(QUAY_PASS)
VERSION := latest

ifneq ($(VERSION), latest)
	export IMAGE_TAG=$(VERSION)
else
	export IMAGE_TAG=latest
endif

login:
	@echo "==> Login to quay.io"
	@echo $(REGISTRY_PASSWORD) | sudo nerdctl login $(REGISTRY_URL) -u $(REGISTRY_USERNAME) --password-stdin

build:
	@echo "==> Build application image with tag $(IMAGE_TAG)"
	@sudo nerdctl build \
		--platform=linux/amd64 \
		-t $(IMAGE_NAME):$(IMAGE_TAG) \
		.

tag:
	@echo "==> Tag the local image as quay.io repository image"
	@sudo nerdctl tag $(IMAGE_NAME):$(IMAGE_TAG) $(REGISTRY_URL)/$(REGISTRY_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)
	@sudo nerdctl tag $(IMAGE_NAME):$(IMAGE_TAG) $(REGISTRY_URL)/$(REGISTRY_USERNAME)/$(IMAGE_NAME):latest

.PHONY: publish
publish: login build tag
	@echo "==> Publish images to quay.io"
	@sudo nerdctl push $(REGISTRY_URL)/$(REGISTRY_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)
	@sudo nerdctl push $(REGISTRY_URL)/$(REGISTRY_USERNAME)/$(IMAGE_NAME):latest
	@echo "==> Finished"

.PHONY: run
run:
	@sudo nerdctl run --rm -it \
				--name $(IMAGE_NAME) \
				-e APP_ID=$(APP_ID) \
				-e GITHUB_APP_KEY=$(PWD)/private-key.pem \
				-v $(PWD)/private-key.pem:/function/private-key.pem \
				$(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: help
help:
	$(info ${HELP_MESSAGE})
	@exit 0

define HELP_MESSAGE

Usage: $ make [TARGETS]

TARGETS

	help            Show the help menu
	build           Build the application image
	run             Run the application container locally (VERSION optional)
	publish         Build the application image, tag it with a custom version tag, and push it to GHCR (Version required)

EXAMPLE USAGE

	build           Build the application image and tag it as latest
	run             Run the application container locally with the latest tag
	publish         Build the application iamge, tag it as v1.0.1, and push it to GHCR

endef
