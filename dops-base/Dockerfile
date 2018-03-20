##{
##  "name": "krkr/dops-base",
##}
FROM krkr/docker-toolbox

# Install Ansible
ENV ANSIBLE_VERSION=2.4.2.0 \
    ANSIBLE_HOST_KEY_CHECKING=False
RUN apk --update add build-base libffi-dev \
    openssl-dev openssh-client \
    python-dev py-pip py-crypto py-jinja2 && \
    pip install ansible==${ANSIBLE_VERSION} && \
    apk del build-base openssl-dev libffi-dev python-dev

# Install Terraform
ENV TERRAFORM_VERSION 0.11.2
RUN apk --update add ca-certificates && \
    curl -sSkL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > /terraform.zip && \
    unzip /terraform.zip && rm /terraform.zip && \
    mv terraform* /usr/local/bin && \
    chmod +x /usr/local/bin/terraform*

# Install Packer
ENV PACKER_VERSION 1.2.1
RUN wget -q "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip && \
    rm packer_${PACKER_VERSION}_linux_amd64.zip && \
    mv packer /usr/local/bin
