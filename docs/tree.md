# Tree example

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
    │   ├── app.yml
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
    │   ├── prod
    │   │   ├── certs
    │   │   │   ├── ca-key.pem.encrypted
    │   │   │   ├── ca.pem.encrypted
    │   │   │   ├── cert.pem.encrypted
    │   │   │   └── key.pem
    │   │   └── machines
    │   │       └── prod-node-1
    │   │           ├── ca.pem.encrypted
    │   │           ├── cert.pem.encrypted
    │   │           ├── config.json.encrypted
    │   │           ├── id_rsa.encrypted
    │   │           ├── id_rsa.pub.encrypted
    │   │           ├── key.pem.encrypted
    │   │           ├── server-key.pem.encrypted
    │   │           └── server.pem.encrypted
    │   └── integ
    │       ├── certs
    │       │   ├── ca-key.pem.encrypted
    │       │   ├── ...
    │       │   └── key.pem.encrypted
    │       ├── machines
    │       │   └── integ-node-1
    │       │       ├── ca.pem.encrypted
    │       │       ├── ...
    │       │       └── server.pem.encrypted
    │       └── machines.disabled
    │ 
    └── Dockerfile