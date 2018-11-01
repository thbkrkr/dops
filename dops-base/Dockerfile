##{
##  "name": "krkr/dops-base",
##}
FROM krkr/docker-toolbox

ENV ANSIBLE_VERSION=2.7.1.0 \
    ANSIBLE_HOST_KEY_CHECKING=False
RUN apk --update add build-base libffi-dev \
    openssl-dev openssh-client \
    python-dev py-pip py-crypto py-jinja2 && \
    pip install ansible==${ANSIBLE_VERSION} && \
    apk del build-base openssl-dev libffi-dev python-dev

ENV TERRAFORM_VERSION 0.11.10
RUN apk --update add ca-certificates && \
    curl -sSkL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > /terraform.zip && \
    unzip /terraform.zip && rm /terraform.zip && \
    mv terraform* /usr/local/bin && \
    chmod +x /usr/local/bin/terraform*

ENV PACKER_VERSION 1.3.2
RUN wget -q "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip && \
    rm packer_${PACKER_VERSION}_linux_amd64.zip && \
    mv packer /usr/local/bin

ENV KUBECTL_VERSION 1.12.2
RUN curl -sSL "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    > /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

ENV HELM_VERSION 2.11.0
RUN wget -q "https://kubernetes-helm.storage.googleapis.com/helm-v${HELM_VERSION}-linux-amd64.tar.gz" && \
    tar xvzf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    rm helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin && \
    rm -rf linux-amd64

RUN apk --no-cache add \
      python-dev py-pip py-setuptools \
      ca-certificates gcc musl-dev linux-headers \
  && pip install --upgrade --no-cache-dir pip setuptools python-openstackclient==3.16.1 \
  && apk del gcc musl-dev linux-headers