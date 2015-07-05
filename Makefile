NAME = krkr/dops
VERSION = 0.1

build: build-docker-machine build-image

build-docker-machine:
	@echo "Build docker-machine..."
	docker build --rm -f build/Dockerfile -t dm-builder build
	@echo "Extract docker-machine..."
	docker run --rm \
		-v $(shell pwd):/here \
		dm-builder sh -c "cp -f /build/docker-machine-* /here/build"

build-image:
	@echo "Build $NAME:latest..."
	docker build --rm -t $(NAME):latest .

release: build
	docker tag -f $(NAME):latest $(NAME):$(VERSION)

push:
	docker push $(NAME)

test:
	@docker run --rm $(NAME):$(VERSION) version jq
	@docker run --rm $(NAME):$(VERSION) version bash
	@docker run --rm $(NAME):$(VERSION) version docker
	@docker run --rm $(NAME):$(VERSION) version docker-machine
	@docker run --rm $(NAME):$(VERSION) version docker-compose
	@docker run --rm $(NAME):$(VERSION) versimon ansible
