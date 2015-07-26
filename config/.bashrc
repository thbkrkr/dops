
PROMPT_MACHINE=""
PROMPT_APP=""

set +u
[ "$MACHINE" != "" ] && \
    PROMPT_MACHINE="[\e[0;36mmachine:\${MACHINE}\e[0m]"

[ "$NAME" != "" ] && PROMPT_APP="[\e[0;33mapp:\${NAME}\e[0m]"
set -u

export PS1="\e[0;35m\w\e[0m $PROMPT_MACHINE $PROMPT_APP\n> "

. utils.sh

. ~/.bash_aliases