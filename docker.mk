.PHONY: docker/rmi-unused
docker/rmi: ##@docker Remove unused images
	$(DOCKER) rmi $( docker images -q -f dangling=true) $(DOCKER_OPTS)

.PHONY: docker/rm-unnused
docker/rm-unnused: ##@docker Remove unused containers
	$(DOCKER) rm $( docker ps -q -f status=exited) $(DOCKER_OPTS)

.PHONY: docker/prune
docker/prune: ##@docker Prune docker images
	$(DOCKER) system prune -f $(DOCKER_OPTS) && docker image prune $(DOCKER_OPTS)

.PHONY: docker/du
docker/du: ##@docker Docker System disk usage
	$(DOCKER) system df -v $(DOCKER_OPTS)
