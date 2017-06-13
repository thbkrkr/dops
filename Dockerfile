##{
##  "name": "krkr/dops",
##}
FROM krkr/dops-base

RUN apk --update add \
    openssl bash git zsh zsh-vcs make jq gettext

# gotty, doo, ons, dotfiles
RUN curl -sL https://github.com/yudai/gotty/releases/download/v0.0.13/gotty_linux_amd64.tar.gz \
        | tar -xz -C /usr/local/bin && \
    curl -s https://raw.githubusercontent.com/thbkrkr/doo/2bb83868c04ca105912a2767465f51d1803c9fb2/doo \
        > /usr/local/bin/doo && chmod +x /usr/local/bin/doo && \
    curl -skL https://github.com/thbkrkr/ons/releases/download/1.3/ons \
        > /usr/local/bin/ons && chmod +x /usr/local/bin/ons && \
    git clone https://github.com/thbkrkr/ansible-playbooks /ansible && \
        cd /ansible && git checkout 6fac443 && \
    curl -sSL https://raw.github.com/thbkrkr/dotfiles/master/bootstrap/light \
        | sh -s 393799d

COPY dict /usr/share/dict
COPY rc /root
COPY bin /usr/local/bin

RUN mkdir /root/.docker && \
    ln -s /ops/.docker/config.json /root/.docker/config.json

WORKDIR /ops
ENTRYPOINT ["start"]
