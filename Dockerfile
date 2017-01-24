##{
##  "name": "krkr/dops",
##}
FROM krkr/dops-base

# bin/vault dependency
RUN apk add --no-cache openssl

# Install git, zsh, make, oh-my-zsh, vim config and go-apish
RUN apk --update add bash git zsh zsh-vcs make jq && \
    rm -f /var/cache/apk/* && \
    git clone https://github.com/robbyrussell/oh-my-zsh.git /root/.oh-my-zsh && \
    mkdir -p /root/.vim/colors && mkdir /root/.vim/bundle} && \
    git clone https://github.com/gmarik/Vundle.vim.git /root/.vim/bundle/Vundle.vim && \
    curl -s https://raw.githubusercontent.com/sickill/vim-monokai/master/colors/monokai.vim \
        > /root/.vim/colors/monokai.vim && \
    curl -s https://github.com/thbkrkr/go-apish/releases/download/1.2/go-apish_linux-amd64 \
        > /usr/local/bin/go-apish && \
    chmod +x /usr/local/bin/go-apish

RUN curl -sL https://github.com/yudai/gotty/releases/download/v0.0.13/gotty_linux_amd64.tar.gz \
        | tar -xz -C /usr/local/bin

# Install thbkrkr/dotfiles
RUN git clone https://github.com/thbkrkr/dotfiles.git /root/.dotfiles && \
    git --git-dir=/root/.dotfiles/.git --work-tree=/root/.dotfiles checkout 611f9bc && \
    cp /root/.dotfiles/resources/pure-thb.zsh-theme /root/.oh-my-zsh/themes/pure-thb.zsh-theme && \
    find /root/.dotfiles -type f -name ".[a-z]*" -exec cp {} /root \; && \
    sed -i "s|root:x:0:0:root:/root:/bin/ash|root:x:0:0:root:/root:/bin/zsh|" /etc/passwd

RUN curl -s https://raw.githubusercontent.com/thbkrkr/doo/56f433c54a98e2ce860f880a1251172ad40d6657/doo \
        > /usr/local/bin/doo && chmod +x /usr/local/bin/doo && \
    curl -skL https://github.com/thbkrkr/ons/releases/download/1.3/ons \
        > /usr/local/bin/ons && chmod +x /usr/local/bin/ons

COPY dict /usr/share/dict
COPY bin /usr/local/bin
COPY rc /root/.rc
COPY rc/.myzshrc /root/.myzshrc

COPY rc/gotty.config /root/.gotty
COPY o.tpl /o/tpl
COPY playbooks /ops/playbooks

WORKDIR /ops
ENTRYPOINT ["run"]
