##{
##  "name": "krkr/ops",
##  "packages": ["docker-1.7.0", "docker-compose-1.3.1", "docker-machine-0.3.0", "curl", "bash", "jq"]
##}
FROM alpine:3.2

ENV DOCKER_VERSION=1.7.0 \
    DOCKER_COMPOSE_VERSION=1.3.1 \
    DOCKER_MACHINE_VERSION=0.3.0

RUN apk --update add bash ca-certificates curl jq \
  && curl https://get.docker.io/builds/Linux/x86_64/docker-${DOCKER_VERSION} > /bin/docker \
  && chmod +x /bin/docker \
  && apk add py-pip \
  && pip install docker-compose==${DOCKER_COMPOSE_VERSION} \
  && rm -f /var/cache/apk/*

ENV ANSIBLE_VERSION 1.9.2

RUN apk --update \
  add \
    openssh-client \
    py-pip py-crypto py-yaml py-jinja2 \
  && rm -f /var/cache/apk/* \
  && pip install ansible==${ANSIBLE_VERSION}

COPY build/docker-machine-${DOCKER_MACHINE_VERSION} /usr/local/bin/docker-machine
RUN mkdir -p /root/.docker

COPY dict /usr/share/dict
COPY bin /usr/local/bin
COPY config /root

WORKDIR /ops
ENTRYPOINT ["start"]