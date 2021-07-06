
.PHONY: build
build: ##@build Build docker image
	@echo "Building docker image..."
	$(DOCKER) build $(DOCKER_OPTS) \
			--build-arg PORT=$(PORT) \
			--build-arg APP_NAME=$(APP_NAME) \
			--build-arg PROFILE=$(PROFILE) \
			--build-arg NODE_ENV=$(NODE_ENV) \
			--build-arg PUBLIC_PATH=$(PUBLIC_PATH) \
			--file $(DOCKERFILE) \
			--tag $(REGISTRY)$(APP_NAME):$(VERSION) $(DOCKER_CONTEXT)

.PHONY: push
push: ##@build Push docker image to repository
	@echo "Pushing image..."
	$(DOCKER) push $(DOCKER_OPTS) $(REGISTRY)$(APP_NAME):$(VERSION)

.PHONY: refresh
refresh: build push ##@build Builds and pushes image to remote repo
	@echo "Refreshing image..."

.PHONY: docker/history
docker/history:  ##@docker Show docker history for image make history
	@echo "Image history use make history"
	$(DOCKER) history $(DOCKER_OPTS) $(REGISTRY)$(APP_NAME):$(VERSION)

.PHONY: dev
dev: ##@develop Running the build image locally without mounts
	$(DOCKER) run -it \
			-p 3000:3000 \
			$(REGISTRY)$(APP_NAME):$(VERSION)

