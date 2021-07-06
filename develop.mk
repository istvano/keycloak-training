.PHONY: yarn/install
yarn/install:: ##@node Install dependencies
	@echo "Installing dependencies"
		$(DOCKER) run --rm -it \
			--mount type=bind,source="$$(pwd)",target=/usr/local/src \
			--workdir=/usr/local/src \
			-u $(UID):$(GID) \
			-e GATSBY_TELEMETRY_DISABLED=1 \
			$(DOCKER_IMG) \
			$(YARN) install

.PHONY: yarn/reset
yarn/reset:: ##@node Delete all dependencies
	@echo "Delete node_modules folder"
		$(DOCKER) run --rm -it \
			--mount type=bind,source="$$(pwd)",target=/usr/local/src \
			--workdir=/usr/local/src \
			-u $(UID):$(GID) \
			-e GATSBY_TELEMETRY_DISABLED=1 \
			$(DOCKER_IMG) \
			rm /usr/local/src/node_modules -rf

.PHONY: yarn/build
yarn/build:: ##@node Build
		$(DOCKER) run --rm -it \
			--mount type=bind,source="$$(pwd)",target=/usr/local/src \
			--workdir=/usr/local/src \
			-u $(UID):$(GID) \
			-e GATSBY_TELEMETRY_DISABLED=1 \
			$(DOCKER_IMG) \
			$(YARN) run docz:build

.PHONY: yarn/dev
yarn/dev:: ##@node Start in Dev mode
		$(DOCKER) run --rm -it \
			-p 3000:3000 \
			--mount type=bind,source="$$(pwd)",target=/usr/local/src \
			--workdir=/usr/local/src \
			-u $(UID):$(GID) \
			-e GATSBY_TELEMETRY_DISABLED=1 \
			$(DOCKER_IMG) \
			$(YARN) run docz:dev

.PHONY: yarn/serve
yarn/serve:: ##@node Serves the project
		$(DOCKER) run --rm -it \
			-p 3000:3000 \
			--mount type=bind,source="$$(pwd)",target=/usr/local/src \
			--workdir=/usr/local/src \
			-u $(UID):$(GID) \
			-e GATSBY_TELEMETRY_DISABLED=1 \
			$(DOCKER_IMG) \
			$(YARN) run docz:build

.PHONY: npm/list
npm/list:: ##@node List packages
		$(DOCKER) run --rm -it \
			-p 3000:3000 \
			--mount type=bind,source="$$(pwd)",target=/usr/local/src \
			--workdir=/usr/local/src \
			-u $(UID):$(GID) \
			-e GATSBY_TELEMETRY_DISABLED=1 \
			$(DOCKER_IMG) \
			$(NPM) ls --depth 0

.PHONY: yarn/outdated
yarn/outdated:: ##@node Lists the outdated packages
		$(DOCKER) run --rm -it \
			-p 3000:3000 \
			--mount type=bind,source="$$(pwd)",target=/usr/local/src \
			--workdir=/usr/local/src \
			-u $(UID):$(GID) \
			-e GATSBY_TELEMETRY_DISABLED=1 \
			$(DOCKER_IMG) \
			$(YARN) outdated

.PHONY: cli
cli:: ##@node Start a cli in the node container
		$(DOCKER) run --rm -it \
			-p 3000:3000 \
			--mount type=bind,source="$$(pwd)",target=/usr/local/src \
			--workdir=/usr/local/src \
			-u $(UID):$(GID) \
			-e GATSBY_TELEMETRY_DISABLED=1 \
			$(DOCKER_IMG) bash