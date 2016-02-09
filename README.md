# dops

A Docker image with ops tools:
  - [Docker](https://docs.docker.com)
  - [Docker Machine](https://docs.docker.com/machine/)
  - [Docker Compose](https://docs.docker.com/compose/)
  - [Terraform](https://terraform.io/docs/)
  - [Ansible](https://docs.ansible.com/ansible/)

Based on [krkr/docker-toolbox](https://github.com/thbkrkr/docker-toolbox).

#### Which versions?

    {"bash":"4.3.42"}
    {"curl":"7.47.0"}
    {"jq":"1.5"}
    {"docker":"1.10.0"}
    {"docker-machine":"0.6.0"}
    {"docker-compose":"1.6.0"}
    {"ansible":"1.9.4"}
    {"terraform":"0.6.10"}

### Using dops

#### zsh in dops

    docker run --rm -ti \
      -v $(pwd):/ops \
      -e MACHINE_STORAGE_PATH=/ops/machine \
      krkr/dops

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

#### Terraform

Write terrform config files in [machine/](https://github.com/thbkrkr/swarm-up/tree/master/machines).

    > docker run --rm -ti \
      -v $(pwd):/ops \
      -w machine \
      krkr/dops \
        terraform apply

#### Ansible

Write [playbooks](https://github.com/thbkrkr/swarm-up/tree/master/ansible).

    > docker run --rm -ti \
      -v $(pwd):/ops \
      -w ansible \
      krkr/dops \
        ansible -i inventory/bim playbooks/all.yml -t docker

## License

MIT
