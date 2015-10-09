NAME = krkr/dops
VERSION = 0.5.0

build: build-docker-machine build-image build-full-image

build-docker-machine:
	@echo "Build docker-machine..."
	docker build --rm -f build-dm/Dockerfile -t dm-builder build-dm
	@echo "Extract docker-machine..."
	docker run --rm \
		-v $(shell pwd):/here \
		dm-builder sh -c "cp -f docker-machine-* /here/build-dm"

build-base-image:
	@echo "Build $(NAME)-base:latest..."
	docker build --rm -t $(NAME)-base:latest  -f Dockerfile.base .

build-image:
	@echo "Build $(NAME):latest..."
	docker build --rm -t $(NAME):latest .

tag:
	docker tag -f $(NAME):latest $(NAME):$(VERSION)

release: build tag

push:
	docker push $(NAME)

test:
	@docker run --rm $(NAME):$(VERSION) version jq
	@docker run --rm $(NAME):$(VERSION) version bash
	@docker run --rm $(NAME):$(VERSION) version docker
	@docker run --rm $(NAME):$(VERSION) version docker-machine
	@docker run --rm $(NAME):$(VERSION) version docker-compose
	@docker run --rm $(NAME):$(VERSION) versimon ansible

dev:
	docker run --rm -ti \
		--volumes-from dev-vaultemort \
		-e OS_API_CREDS_PATHX=/vaultemort/ovh-cloud/openstack-buiot-creds.sh \
		-e OS_API_CREDS_PATH=/vaultemort/runabove-cloud/openstack-thbcorp-creds.sh \
		-e MACHINE_STORAGE_PATH=/vaultemort/machines/tsaas-dev \
		-v $$(pwd)/bin:/usr/local/bin \
		-v $$(pwd)/api:/api \
		-p 80:4242 \
		$(NAME) zsh