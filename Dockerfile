##{
##  "name": "krkr/dops",
##}
FROM krkr/dops-base

RUN apk --update add \
    openssl bash git zsh zsh-vcs make jq

# gotty, doo, ons, dotfiles
RUN curl -sL https://github.com/yudai/gotty/releases/download/v0.0.13/gotty_linux_amd64.tar.gz \
        | tar -xz -C /usr/local/bin && \
    curl -s https://raw.githubusercontent.com/thbkrkr/doo/56f433c54a98e2ce860f880a1251172ad40d6657/doo \
        > /usr/local/bin/doo && chmod +x /usr/local/bin/doo && \
    curl -skL https://github.com/thbkrkr/ons/releases/download/1.3/ons \
        > /usr/local/bin/ons && chmod +x /usr/local/bin/ons && \
    curl -sSL https://raw.github.com/thbkrkr/dotfiles/master/bootstrap/light \
        | sh -s 19fffee

COPY dict /usr/share/dict
COPY rc /root
COPY bin /usr/local/bin
COPY o.tpl /o/tpl
COPY playbooks /ops/playbooks

WORKDIR /ops
ENTRYPOINT ["run"]
