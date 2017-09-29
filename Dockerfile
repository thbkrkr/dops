##{
##  "name": "krkr/dops",
##}
FROM krkr/dops-base

RUN apk --update add \
    openssl bash git zsh zsh-vcs make jq gettext

# gotty, doo, oq, ons, dotfiles, docker-machine-certs
RUN curl -sSL https://github.com/yudai/gotty/releases/download/v0.0.13/gotty_linux_amd64.tar.gz \
        | tar -xz -C /usr/local/bin && \
    curl -sSL https://raw.githubusercontent.com/thbkrkr/doo/b3a90ab3ba1b3375e9a9a2ec20da868473971205/doo \
        > /usr/local/bin/doo && chmod +x /usr/local/bin/doo && \
    curl -sSL https://github.com/thbkrkr/qli/releases/download/0.2.3/oq \
        > /usr/local/bin/oq && chmod +x /usr/local/bin/oq && \
    curl -sSL https://github.com/thbkrkr/ons/releases/download/1.3/ons \
        > /usr/local/bin/ons && chmod +x /usr/local/bin/ons && \
    git clone https://github.com/thbkrkr/ansible-playbooks /ansible && \
        cd /ansible && git checkout 6fac443 && \
    curl -sSL https://raw.github.com/thbkrkr/dotfiles/master/bootstrap/light \
        | sh -s 15e4200 && \
    curl -sSL https://github.com/sebgl/docker-machine-certs/releases/download/0.1/docker-machine-certs \
        > /usr/local/bin/docker-machine-certs && chmod +x /usr/local/bin/docker-machine-certs

COPY dict /usr/share/dict
COPY rc /root
COPY bin /usr/local/bin

RUN mkdir /root/.docker && \
    ln -s /ops/.docker/config.json /root/.docker/config.json

WORKDIR /ops
ENTRYPOINT ["start"]
