NAME = krkr/dops

build: build-base-image build-image

build-base-image:
	@cd dops-base && doo b

build-image:
	@doo b

versions:
	@docker run --rm $(NAME):latest whichversion bash
	@docker run --rm $(NAME):latest whichversion curl
	@docker run --rm $(NAME):latest whichversion jq
	@docker run --rm $(NAME):latest whichversion docker
	@docker run --rm $(NAME):latest whichversion docker-machine
	@docker run --rm $(NAME):latest whichversion docker-compose
	@docker run --rm $(NAME):latest whichversion ansible
	@docker run --rm $(NAME):latest whichversion terraform
