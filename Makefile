IMAGE_NAME = openstack-starter
CONTAINER_NAME = $(IMAGE_NAME)-shell

# List of files used in the test environement (container)
run_files = .env openrc.sh main.tf .terraform.lock.hcl ansible.cfg site.yml test.sh

# Test if container is running
running = $(shell docker ps --filter name=^$(CONTAINER_NAME)$$ --quiet)

build: run .docker-cp.lock 

# The lock file prevent to copy 'run_files' without changes.
.docker-cp.lock: $(run_files)
	@touch $@
	@echo -e "Copy this files in the container : $?";
	@for file in $?; do \
		docker cp $$file $(CONTAINER_NAME):/root/; \
	done

image:
	docker build --tag $(IMAGE_NAME) .

run: 
ifeq ($(running),)
	@rm --force .docker-cp.lock
	docker run --interactive --tty --detach --rm --name $(CONTAINER_NAME) $(IMAGE_NAME) /bin/bash
endif

# Note that you can detach from a container with the Ctrl-P Ctrl-Q sequence.
shell: build
	docker attach $(CONTAINER_NAME)

stop:
ifneq ($(running),)
	docker rm --force $(CONTAINER_NAME)
endif

clean: stop
	docker rmi $(IMAGE_NAME)

# TODO: use docker image
#gitlab-ci:
#	gitlab-runner exec docker --docker-pull-policy=if-not-present build-job

# TODO: register with config file
#gitlab-register:


.PHONY: build image run shell stop clean gitlab-ci gitlab-register
