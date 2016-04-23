##{
##  "name": "krkr/dops-base",
##}
FROM krkr/docker-toolbox

# Install Ansible
ENV ANSIBLE_VERSION 1.9.4
RUN apk --update add openssh-client \
    py-pip py-crypto py-yaml py-jinja2 && \
    pip install ansible==${ANSIBLE_VERSION}

# Install Terraform
ENV TERRAFORM_VERSION 0.6.15
RUN apk --update add ca-certificates && \
    curl -sSkL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > /terraform.zip && \
    unzip /terraform.zip && rm /terraform.zip && \
    mv terraform* /usr/local/bin && \
    chmod +x /usr/local/bin/terraform*
