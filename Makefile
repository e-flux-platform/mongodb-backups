DOCKER_REPOSITORY ?= quay.io/road
BRANCH_NAME ?= $(shell git rev-parse --abbrev-ref HEAD)
GIT_HASH ?= $(shell git rev-parse HEAD)
RELEASE_ID ?= $(shell id -un)-local
DOCKER_LATEST_TAG ?= latest

build:
	docker buildx build \
	--provenance mode=min,inline-only=true \
	--tag $(DOCKER_REPOSITORY)/mongodb-backups:$(GIT_HASH) \
	--tag $(DOCKER_REPOSITORY)/mongodb-backups:$(DOCKER_LATEST_TAG) \
	--tag $(DOCKER_REPOSITORY)/mongodb-backups:release-$(RELEASE_ID) \
	--push \
	.

push: build
