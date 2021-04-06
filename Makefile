
all: build run

build:
	docker build -t openstack-starter .

run:
	docker run -it --rm openstack-starter /bin/bash

gitlab-ci:
	# TODO: use docker image
	gitlab-runner exec docker --docker-pull-policy=if-not-present build-job

gitlab-register:
	# TODO: register with config file

clean:
	docker rmi openstack-starter

.PHONY: all build run gitlab-ci gitlab-register clean
