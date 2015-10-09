##{
##  "name": "krkr/dm-builder",
##  "packages": ["go"]
##}
#
# Docker image to build docker-machine binary.
#
# Mix https://github.com/kiasaki/docker-alpine-golang/blob/master/Dockerfile
# and https://github.com/docker/machine/blob/master/Dockerfile
#
FROM alpine:3.2

RUN apk --update add \
  curl git mercurial bzr go build-base \
  && rm -rf /var/cache/apk/*

ENV GOPATH /go
ENV DOCKER_MACHINE_VERSION 0.4.1

# TODO: Vendor these `go get` commands using Godep.
RUN go get github.com/mitchellh/gox
RUN go get github.com/aktau/github-release
RUN go get github.com/tools/godep
RUN go get golang.org/x/tools/cmd/cover

ENV GOPATH /go/src/github.com/docker/machine/Godeps/_workspace:/go
WORKDIR /go/src/github.com/docker/machine

RUN git clone https://github.com/docker/machine . \
  && git checkout v${DOCKER_MACHINE_VERSION}

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o docker-machine-${DOCKER_MACHINE_VERSION} .
