# dops

[![Docker Pulls](https://img.shields.io/docker/pulls/krkr/dops.svg)](https://hub.docker.com/r/krkr/dops/)

A Docker image with ops tools:
  - [Docker](https://docs.docker.com)
  - [Docker Machine](https://docs.docker.com/machine/)
  - [Docker Compose](https://docs.docker.com/compose/)
  - [Terraform](https://terraform.io/docs/)
  - [Packer](https://packer.io/docs/)
  - [Kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
  - [Ansible](https://docs.ansible.com/ansible/)

Based on [krkr/docker-toolbox](https://github.com/thbkrkr/docker-toolbox).

```sh
      _
   __| | ___  _ __  ___
  / _` |/ _ \| |_ \/ __|
 | (°| < (#) < |_) \__ \
  \__,_|\___/| .__/|___/
             |_|

```

#### Which versions?

```sh
{"bash":"4.4.19"}
{"curl":"7.57.0"}
{"jq":"1.5"}
{"docker":"18.01.0"}
{"docker-machine":"0.13.0"}
{"docker-compose":"1.18.0"}
{"ansible":"2.5.2.0"}
{"terraform":"0.11.7"}
{"packer":"1.2.3"}
{"kubectl":"1.10.2"}
{"helm":"2.9.0"}
{"openstackclient":"3.15.0"}
```

### Using dops

#### zsh in dops

```sh
> docker run --rm -ti \
  -v $(pwd):/ops \
  -e CLUSTER=c1.bim \
  krkr/dops

/ops  [cluster:c1.bim] [node:n1.c1.bim] root@io
> ...
```

## License

MIT
