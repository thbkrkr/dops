NAME := krkr/dops
SHA1 := $(shell git rev-parse --short HEAD)

build: build-base-image build-image

build-base-image:
	@cd dops-base && doo b

build-image:
	@doo b

tag:
	docker tag $(NAME) $(NAME):$(SHA1)

push:
	docker push $(NAME):$(SHA1)

versions:
	@docker run --rm -e VAULT_KEY=x $(NAME):latest whichversion bash
	@docker run --rm -e VAULT_KEY=x $(NAME):latest whichversion curl
	@docker run --rm -e VAULT_KEY=x $(NAME):latest whichversion jq
	@docker run --rm -e VAULT_KEY=x $(NAME):latest whichversion docker
	@docker run --rm -e VAULT_KEY=x $(NAME):latest whichversion docker-machine
	@docker run --rm -e VAULT_KEY=x $(NAME):latest whichversion docker-compose
	@docker run --rm -e VAULT_KEY=x $(NAME):latest whichversion ansible
	@docker run --rm -e VAULT_KEY=x $(NAME):latest whichversion terraform
	@docker run --rm -e VAULT_KEY=x $(NAME):latest whichversion packer
