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
ENV TERRAFORM_VERSION 0.11.1
RUN apk --update add ca-certificates && \
    curl -sSkL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > /terraform.zip && \
    unzip /terraform.zip && rm /terraform.zip && \
    mv terraform* /usr/local/bin && \
    chmod +x /usr/local/bin/terraform*
