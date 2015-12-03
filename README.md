# dops

A Docker image with ops tools:
  - [Docker](https://docs.docker.com)
  - [Docker Machine](https://docs.docker.com/machine/)
  - [Docker Compose](https://docs.docker.com/compose/)
  - [Terraform](https://terraform.io/docs/)
  - [Ansible](https://docs.ansible.com/ansible/)

Based on the [Alpine Linux](https://www.alpinelinux.org).

## Using dops

	docker run --rm -ti \
		-v $(pwd):/ops \
		-e MACHINE_STORAGE_PATH=/ops/machines \
		dops

## License

MIT
