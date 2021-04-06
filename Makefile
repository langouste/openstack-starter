IMAGE_NAME := openstack-starter
CONTAINER_NAME := $(IMAGE_NAME)-shell
COPY_STATE_FILE := .makefile.docker-cp.state
TAG_STATE_FILE := .makefile.image-build.state

# List of files used in the test environement (container)
run_files = .env openrc.sh main.tf .terraform.lock.hcl ansible.cfg site.yml create-server.sh

# Test if container is running
running = $(shell docker ps --filter name=^$(CONTAINER_NAME)$$ --quiet)

# Timestamp is used as tag for docker image
timestamp = $(shell date +%s)
tag = $(shell cat $(TAG_STATE_FILE))

images = $(shell docker images --filter reference=$(IMAGE_NAME):* --format "{{.Repository}}:{{.Tag}}")

# default rule 
build: up $(COPY_STATE_FILE) 

# The 'state' file prevent to copy 'run_files' without changes.
$(COPY_STATE_FILE): $(run_files)
	@touch $@
	@echo "Copy this files in the container : $?";
	@for file in $?; do \
		docker cp $$file $(CONTAINER_NAME):/root/; \
	done

image: $(TAG_STATE_FILE)

$(TAG_STATE_FILE): Dockerfile
	@echo $(timestamp) > $(TAG_STATE_FILE)
	docker build --tag $(IMAGE_NAME):$(timestamp) .
	@if [ -n "$(running)" ]; then \
		echo "Restart container with new image"; \
		$(MAKE) --quiet stop; \
		$(MAKE) --quiet run; \
	fi

run: 
ifeq ($(running),)
	@rm --force $(COPY_STATE_FILE)
	docker run --interactive --tty --detach --rm --name $(CONTAINER_NAME) $(IMAGE_NAME):$(tag) /bin/bash
endif

up: image run

# Note that you can detach from a container with the Ctrl-P Ctrl-Q sequence.
shell: build
	docker attach $(CONTAINER_NAME)

stop:
ifneq ($(running),)
	docker rm --force $(CONTAINER_NAME)
endif

clean: stop
	@rm --force $(TAG_STATE_FILE)
	@if [ -n "$(images)" ]; then \
		echo "docker rmi (...)"; \
		docker rmi $(images); \
	fi

# TODO: use docker image
#gitlab-ci:
#	gitlab-runner exec docker --docker-pull-policy=if-not-present build-job

# TODO: register with config file
#gitlab-register:


.PHONY: build image run up shell stop clean gitlab-ci gitlab-register
