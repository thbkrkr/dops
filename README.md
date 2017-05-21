# dops

[![Docker Pulls](https://img.shields.io/docker/pulls/krkr/dops.svg)](https://hub.docker.com/r/krkr/dops/)

A Docker image with ops tools:
  - [Docker](https://docs.docker.com)
  - [Docker Machine](https://docs.docker.com/machine/)
  - [Docker Compose](https://docs.docker.com/compose/)
  - [Terraform](https://terraform.io/docs/)
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
{"bash":"4.3.46"}
{"curl":"7.52.1"}
{"jq":"1.5"}
{"docker":"17.05.0"}
{"docker-machine":"0.11.0"}
{"docker-compose":"1.13.0"}
{"ansible":"2.3.0.0"}
{"terraform":"0.9.4"}
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

#### Create a VM on [OVH Cloud](https://www.ovh.com/fr/vps/vps-ssd.xml)

Get your OpenStack creds.

```sh
> cat machine/env/os-creds.secrets.env
OS_AUTH_URL=https://auth.cloud.ovh.net/v2.0
OS_TENANT_ID=?
OS_TENANT_NAME=?
OS_USERNAME=?
OS_PASSWORD=?
OS_REGION_NAME=BHS1
```

Create a VM using docker-machine and the [OVH driver](https://github.com/yadutaf/docker-machine-driver-ovh).

```sh
  > docker run --rm -ti \
    -v $(pwd):/ops \
    -e CLUSTER=c1.bim
    krkr/dops \
      docker-machine create -d ovh n1.c1.bim
```

#### Or create your infra with Terraform

Write Terraform config files (example: [create a Swarm cluster](https://github.com/thbkrkr/swarm-up/blob/master/machines/bim/swarm.tf)).

```sh
> docker run --rm -ti \
  krkr/dops \
    terraform apply
```

#### And/or run Ansible

Write [inventory](https://github.com/thbkrkr/swarm-up/blob/master/ansible/inventory/bim/machines.sh) and [playbooks](https://github.com/thbkrkr/swarm-up/blob/master/ansible%2Fplaybooks%2Fswarm.yml) (example to install docker-machine on nodes managed by Terraform).

```sh
> docker run --rm -ti \
  krkr/dops \
    ansible-playbook ansible/all.yml -t docker
```

## License

MIT
