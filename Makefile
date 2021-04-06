
all: build bash

build:
	docker build -t openstack-starter .

bash:
	docker run -it --rm openstack-starter bash

show:
	openstack server list

gitlab-ci:
	gitlab-runner exec docker --docker-pull-policy=if-not-present build-job
	

.PHONY: all build show gitlab-ci
