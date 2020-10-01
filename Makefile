.SILENT:
.PHONY: build-protonmail-bridge push-protonmail-bridge
# Colors
COLOR_RESET   = \033[0m
COLOR_INFO    = \033[32m
COLOR_COMMENT = \033[33m
COLOR_ERROR   = \033[31m

## Help
help:
	printf "$(COLOR_COMMENT)Usage:$(COLOR_RESET)\n"
	printf " make [target]\n\n"
	printf "$(COLOR_COMMENT)Available targets:$(COLOR_RESET)\n"
	awk '/^[a-zA-Z\-\_0-9\.@]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf " ${COLOR_INFO}%-24s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

#####################
# Protonmail-bridge #
#####################

PROTONMAIL-BRIDGE_VERSION = 1.3.3

## Build protonmail-bridge image(s)
build-protonmail-bridge:
	docker build \
		--tag greedybro/protonmail-bridge:$(PROTONMAIL-BRIDGE_VERSION) \
		--build-arg PROTONMAIL-BRIDGE_VERSION=$(PROTONMAIL-BRIDGE_VERSION) \
		protonmail-bridge

## Run temporary protonmail-bridge container
run-protonmail-bridge:
	docker run \
		--rm \
		--interactive \
		--tty \
		greedybro/protonmail-bridge:$(PROTONMAIL-BRIDGE_VERSION) \
		--help

## Sh into temporary protonmail-bridge container
sh-protonmail-bridge:
	docker run \
		--rm \
		--interactive \
		--tty \
		--entrypoint /bin/ash \
		greedybro/protonmail-bridge:$(PROTONMAIL-BRIDGE_VERSION)

## Publish protonmail-bridge image(s)
push-protonmail-bridge:
	$(call docker_login)
	docker push \
		greedybro/protonmail-bridge:$(PROTONMAIL-BRIDGE_VERSION)
