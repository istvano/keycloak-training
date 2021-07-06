#using https://github.com/25th-floor/docker-make-stub
# ------------------------------ HELPER Scripts BEGIN ----------------------------
BLUE      := $(shell tput -Txterm setaf 4)
GREEN     := $(shell tput -Txterm setaf 2)
TURQUOISE := $(shell tput -Txterm setaf 6)
WHITE     := $(shell tput -Txterm setaf 7)
YELLOW    := $(shell tput -Txterm setaf 3)
GREY      := $(shell tput -Txterm setaf 1)
RESET     := $(shell tput -Txterm sgr0)

SMUL      := $(shell tput smul)
RMUL      := $(shell tput rmul)

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
HELP_FUN = \
	%help; \
	use Data::Dumper; \
	while(<>) { \
		if (/^([_a-zA-Z\-\/]+)\s*:.*\#\#(?:@([a-zA-Z\-\/_\s]+))?\t(.*)$$/ \
			|| /^([_a-zA-Z\-\/]+)\s*:.*\#\#(?:@([a-zA-Z\-\/]+))?\s(.*)$$/) { \
			$$c = $$2; $$t = $$1; $$d = $$3; \
			push @{$$help{$$c}}, [$$t, $$d, $$ARGV] unless grep { grep { grep /^$$t$$/, $$_->[0] } @{$$help{$$_}} } keys %help; \
		} \
	}; \
	for (sort keys %help) { \
		printf("${WHITE}%24s:${RESET}\n\n", $$_); \
		for (@{$$help{$$_}}) { \
			printf("%s%25s${RESET}%s  %s${RESET}\n", \
				( $$_->[2] eq "Makefile" || $$_->[0] eq "help" ? "${YELLOW}" : "${GREY}"), \
				$$_->[0], \
				( $$_->[2] eq "Makefile" || $$_->[0] eq "help" ? "${GREEN}" : "${GREY}"), \
				$$_->[1] \
			); \
		} \
		print "\n"; \
	} 

# make
.DEFAULT_GOAL := help

# Variable wrapper
define defw
	custom_vars += $(1)
	$(1) ?= $(2)
	export $(1)
	shell_env += $(1)="$$($(1))"
endef

# Variable wrapper for hidden variables
define defw_h
	$(1) := $(2)
	shell_env += $(1)="$$($(1))"
endef

.PHONY: help
help:: ##@Other Show this help.
	@echo ""
	@printf "%30s " "${BLUE}VARIABLES"
	@echo "${RESET}"
	@echo ""
	@printf "${BLUE}%25s${RESET}${TURQUOISE}  ${SMUL}%s${RESET}\n" $(foreach v, $(custom_vars), $v $(if $($(v)),$($(v)), ''))
	@echo ""
	@echo ""
	@echo ""
	@printf "%30s " "${YELLOW}TARGETS"
	@echo "${RESET}"
	@echo ""
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

# ------------------------------ HELPER Scripts END ----------------------------	

#commands
$(eval $(call defw,NPM,npm))
$(eval $(call defw,YARN,yarn))
$(eval $(call defw,MAKE,make))
$(eval $(call defw,DOCKER,docker))
$(eval $(call defw,GIT,git))

#variables
BASENAME=$(shell basename $(PWD))
$(eval $(call defw,BASENAME,${BASENAME}))

USERNAME=$(shell whoami)
$(eval $(call defw,USERNAME,$(USERNAME)))

UID=$(shell id -u $(USERNAME))
GID=$(shell id -g $(USERNAME))

BUILD_DATE := $(shell date -R)

#version
#VERSION=$(shell cat .version | sed 's/[",]//g' | tr -d '[[:space:]]')
PACKAGE_VERSION=$(shell cat ./package.json | grep version | head -1 | awk -F: '{ print $2 }' | sed 's/[",]//g' | tr -d '[[:space:]]')
ver=version:
verionremoved=$(subst $(ver),,$(PACKAGE_VERSION))
VERSION=$(strip $(verionremoved))
$(eval $(call defw,VERSION,$(VERSION)))

#app name
PACKAGE_NAME=$(shell cat ./package.json | grep name | head -1 | awk -F: '{ print $2 }' | sed 's/[",]//g' | sed "s/'//g" | sed 's/&project_name//g' | tr -d '[[:space:]]')
name=name:
nameemoved=$(subst $(name),,$(PACKAGE_NAME))
NAME=$(strip $(nameemoved))
$(eval $(call defw,APP_NAME,$(NAME)))

#docker
DOCKER_IMG=node:12.22-slim
DOCKER_OPTS=
DOCKERFILE=./Dockerfile
DOCKER_CONTEXT=.
PORT=3000

$(eval $(call defw,PROFILE,dev))
$(eval $(call defw,NODE_ENV,development))
$(eval $(call defw,PUBLIC_PATH,/))
$(eval $(call defw,PORT,3000))
$(eval $(call defw,REGISTRY,localhost:32000/))

IMAGE_ID=$(shell $(DOCKER) images | grep roadmappro | grep latest | head -1 | awk '{ print $$1 }')
$(eval $(call defw,IMAGE_ID,$(IMAGE_ID)))

#env
$(eval $(call defw,ENV,development))
$(eval $(call defw,PREFIX,cf))
$(eval $(call defw,NAMESPACE))

ifeq ($(strip $(CATEGORY)),)
    NAMESPACE=$(PREFIX)-application
else
	NAMESPACE=$(PREFIX)-$(CATEGORY)
endif

#dns
$(eval $(call defw,DOMAINS,roadmap.e-change.co))
$(eval $(call defw,IP_ADDRESS,::1))

#import makefiles
include ./*.mk
