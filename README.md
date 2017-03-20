# dops

[![Docker Pulls](https://img.shields.io/docker/pulls/krkr/dops.svg)](https://hub.docker.com/r/krkr/dops/)

A Docker image with ops tools:
  - [Docker](https://docs.docker.com)
  - [Docker Machine](https://docs.docker.com/machine/)
  - [Docker Compose](https://docs.docker.com/compose/)
  - [Terraform](https://terraform.io/docs/)
  - [Ansible](https://docs.ansible.com/ansible/)

Based on [krkr/docker-toolbox](https://github.com/thbkrkr/docker-toolbox).

#### Which versions?

```
{"bash":"4.3.46"}
{"curl":"7.52.1"}
{"jq":"1.5"}
{"docker":"17.03.0"}
{"docker-machine":"0.10.0"}
{"docker-compose":"1.11.2"}
{"ansible":"2.2.1.0"}
{"terraform":"0.9.1"}
```

### Using dops

#### zsh in dops

```
> docker run --rm -ti \
  -v $(pwd):/ops \
  -e MACHINE_STORAGE_PATH=/ops/machines \
  krkr/dops:latest
  _
   __| | ___  _ __  ___
  / _` |/ _ \| |_ \/ __|
 | (°| < (#) < |_) \__ \
  \__,_|\___/| .__/|___/
             |_|
 -----------------------
 Welcome in dops!

No docker MACHINE defined. No docker environment set!

/ops  [cluster:machine] [node:n1] root@io
> ...
```

#### Create a VM on [OVH Cloud](https://www.ovh.com/fr/vps/vps-ssd.xml)

Get your OpenStack creds.

    > cat machine/os-api-creds.env
    OS_AUTH_URL=https://auth.cloud.ovh.net/v2.0
    OS_TENANT_ID=?
    OS_TENANT_NAME=?
    OS_USERNAME=?
    OS_PASSWORD=?
    OS_REGION_NAME=BHS1

Create a VM using docker-machine and the [OVH driver](https://github.com/yadutaf/docker-machine-driver-ovh).

    > docker run --rm -ti \
      -v $(pwd):/ops \
      --env-file $(pwd)/machine/os-api-creds.env \
      -e MACHINE_STORAGE_PATH=/ops/machine \
      krkr/dops \
        docker-machine create -d ovh node-1

#### Or create your infra with Terraform

Write Terraform config files (example: [create a Swarm cluster](https://github.com/thbkrkr/swarm-up/blob/master/machines/bim/swarm.tf)).

    > docker run --rm -ti \
      -v $(pwd):/ops \
      -w machine/bim \
      krkr/dops \
        terraform apply

#### Or run Ansible

Write [inventory](https://github.com/thbkrkr/swarm-up/blob/master/ansible/inventory/bim/machines.sh) and [playbooks](https://github.com/thbkrkr/swarm-up/blob/master/ansible%2Fplaybooks%2Fswarm.yml) (example to install docker-machine on nodes managed by Terraform).

    > docker run --rm -ti \
      -v $(pwd):/ops \
      -w ansible \
      krkr/dops \
        ansible -i inventory/bim playbooks/all.yml -t docker

## License

MIT
