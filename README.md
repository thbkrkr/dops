# dops

dops is a Docker image with [Docker](https://docs.docker.com), [Machine](https://docs.docker.com/machine/),
[Compose](https://docs.docker.com/compose/) and [Ansible](docs.ansible.com) based on 
[Alpine Linux](https://www.alpinelinux.org).

It contains some [scripts](bin) to ease the use of this tools.

## Using dops

### Directories conventions

If you want use the tools scripts, each one expects some directories ([example](docs/tree.md)).

##### [`play`](bin/play) (Ansible wrapper):

  - /ops/ansible/inventories
  - /ops/ansible/playbooks

###### Run playbooks

    > play -i prod -p boostrap

###### Execute commands

    > play -i prod -e "uname -a"

##### [`dc`](bin/dc) (Compose wrapper):

  - /ops/config/dockercfg.json
  - /ops/machines/
  - /ops/compose/

###### Run Compose choosing a project name, a reference file and a machine

    > NAME=app MACHINE=node-int-1 dc
    > N=app M=node-int-1 dc

##### [`create-openstack-vm`](bin/create-openstack-vm) (Machine wrapper):

  - /ops/config/creds-openrc.sh

###### Create a VM choosing its name and flavour

    > create-openstack-vm -n node-int-2 -f vps-ssd-3 -f

Docker Machine:

  - /ops/machines/

### Build

    FROM krkr/ops:0.2

    COPY . /ops

    # Decrypt sensitive files and link .dockercfg file and machines/ dir config.
    RUN crypt decrypt \
      && ln -s /ops/config/dockercfg /root/.dockercfg \
      && ln -s /ops/machines /root/.docker/machine/machines

Then:

    > docker build --rm -t <org>/ops .

### Run

    > docker run --rm -ti <org>/ops <create-openstack-vm|play|dc|dm>

### Encrypt and decrypt sensitive files

See [crypt](bin/crypt).

    > docker run --rm -ti -v $(pwd):/ops <org>/ops crypt encrypt
    > docker run --rm -ti -v $(pwd):/ops <org>/ops crypt decrypt
    > docker run --rm -ti -v $(pwd):/ops <org>/ops crypt rm-sensitive-files

## [Changelog](CHANGELOG.md)

## [License](LICENSE)
