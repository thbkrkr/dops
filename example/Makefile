go: build
	docker run --rm -ti \
		-v $$(pwd):/ops \
		--env-file .env \
		dops-example

build:
	docker build -t dops-example .
