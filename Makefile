# Variables
DOCKER_IMAGE=alvarofpp/docker-image-name
DOCKER_IMAGE_LINTER=alvarofpp/base:linter
ROOT=$(shell pwd)
DIR=image/
LINT_COMMIT_TARGET_BRANCH=origin/main

# Commands
.PHONY: install-hooks
install-hooks:
	git config core.hooksPath .githooks

.PHONY: build
build: install-hooks
	@docker build ${DIR} -t ${DOCKER_IMAGE}

.PHONY: build-no-cache
build-no-cache: install-hooks
	@docker build ${DIR} -t ${DOCKER_IMAGE} --no-cache

.PHONY: push
push:
	@docker push ${DOCKER_IMAGE}

.PHONY: lint
lint:
	@docker pull ${DOCKER_IMAGE_LINTER}
	@docker run --rm -v ${ROOT}:/app ${DOCKER_IMAGE_LINTER} " \
		lint-commit ${LINT_COMMIT_TARGET_BRANCH} \
		&& lint-markdown \
		&& lint-dockerfile \
		&& lint-shell-script \
		&& lint-yaml"
