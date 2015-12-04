##{
##  "name": "krkr/dops",
##}
FROM krkr/dops-base

# Install git, zsh, make, oh-my-zsh, vim config and go-apish
RUN apk --update add bash git zsh make jq && \
    rm -f /var/cache/apk/* && \
    git clone https://github.com/robbyrussell/oh-my-zsh.git /root/.oh-my-zsh && \
    mkdir -p /root/.vim/colors && mkdir /root/.vim/bundle} && \
    git clone https://github.com/gmarik/Vundle.vim.git /root/.vim/bundle/Vundle.vim && \
    curl -s https://raw.githubusercontent.com/sickill/vim-monokai/master/colors/monokai.vim \
      > /root/.vim/colors/monokai.vim && \
    wget -q https://github.com/thbkrkr/go-apish/releases/download/1.1/go-apish_linux-amd64 \
      -O /usr/local/bin/go-apish && \
    chmod +x /usr/local/bin/go-apish

# Install thbkrkr/dotfiles
RUN git clone https://github.com/thbkrkr/dotfiles.git /root/.dotfiles && \
    curl -s https://raw.githubusercontent.com/thbkrkr/dotfiles/master/resources/pure-thb.zsh-theme \
      > /root/.oh-my-zsh/themes/pure-thb.zsh-theme && \
    find /root/.dotfiles -type f -name ".[a-z]*" -exec cp {} /root \; && \
    sed -i "s|root:x:0:0:root:/root:/bin/ash|root:x:0:0:root:/root:/bin/zsh|" /etc/passwd

COPY dict /usr/share/dict
COPY bin /usr/local/bin
COPY rc /root

WORKDIR /ops
CMD ["zsh"]