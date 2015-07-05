# dops

dops is a Docker image with [Docker](https://docs.docker.com), [Docker Machine](https://docs.docker.com/machine/),
[Docker Compose](https://docs.docker.com/compose/) and [Ansible](docs.ansible.com) based on 
[Alpine Linux](https://www.alpinelinux.org).

It contains some [wrapper scripts](bin) to ease the use of Ansible, Docker Compose and Docker Machine with the OpenStack driver.

## Using dops

### Directories conventions

If you want use the wrapper scripts, each one expects some directories.

`play` (Ansible wrapper):

  - /ops/ansible/inventories
  - /ops/ansible/playbooks

`dc` (Docker Compose wrapper):

  - /ops/config/dockercfg.json
  - /ops/machines/
  - /ops/compose/

`create-openstack-vm`:

  - /ops/config/creds-openrc.sh

Docker Machine:

  - /ops/machines/

Example:

    ├── ansible
    │   ├── inventories
    │   │   ├── ci
    │   │   ├── integ
    │   │   └── prod
    │   ├── keys
    │   │   └── user.id_rsa
    │   ├── play
    │   └── playbooks
    │       ├── bootstrap.yml
    │       ├── install-xyz.yml
    │       ├── ...
    │       └── roles
    │           └── ...
    ├── compose
    │   ├── app1.yml
    │   ├── backup
    │   │   ├── save.yml
    │   │   └── restore.yml
    │   ├── ci.yml
    │   ├── ...
    │   └── logging.yml
    ├── config
    │   ├── creds-openrc.sh.encrypted
    │   └── dockercfg.json.encrypted
    ├── images
    │   ├── app
    │   │   └── app1
    │   │       ├── Dockerfile
    │   │       └── files
    │   │           └── ...
    │   ├── core
    │   │   ├── nodejs
    │   │   │   └── Dockerfile
    │   │   └── nginx
    │   │       └── Dockerfile
    │   └── ...
    ├── machines
    │   ├── m1
    │   │   ├── ca.pem.encrypted
    │   │   ├── cert.pem.encrypted
    │   │   ├── config.json.encrypted
    │   │   ├── id_rsa.encrypted
    │   │   ├── id_rsa.pub.encrypted
    │   │   ├── key.pem.encrypted
    │   │   ├── server-key.pem.encrypted
    │   │   └── server.pem.encrypted
    │   ├── ...
    │   └── ...
    └── Dockerfile

### Build

    FROM krkr/ops:0.1

    COPY . /ops

    # Decrypt sensitive files and link .dockercfg file and machines/ dir config.
    RUN crypt decrypt \
      && ln -s /ops/config/dockercfg /root/.dockercfg \
      && mkdir -p /root/.docker/machine \
      && ln -s /ops/machines /root/.docker/machine/machines

Then:

    > docker build --rm -t <org>/ops .

### Run

    > docker run --rm -ti <org>/ops <create-openstack-vm|play|dc|dm>

## [Changelog](CHANGELOG.md)

## [License](LICENSE)
