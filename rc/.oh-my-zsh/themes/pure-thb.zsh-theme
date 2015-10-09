# Fork of the awesome pretty, minimal and fast ZSH prompt Pure made by @sindresorhus.
# ----
# Pure
# by Sindre Sorhus
# https://github.com/sindresorhus/pure
# MIT License

# For my own and others sanity
# git:
# %b => current branch
# %a => current action (rebase/merge)
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)

LANG="en_US git"
LC_ALL="en_US git"

# turns seconds into human readable time
# 165392 => 1d 21h 56m 32s
prompt_pure_human_time() {
	local tmp=$1
	local days=$(( tmp / 60 / 60 / 24 ))
	local hours=$(( tmp / 60 / 60 % 24 ))
	local minutes=$(( tmp / 60 % 60 ))
	local seconds=$(( tmp % 60 ))
	(( $days > 0 )) && echo -n "${days}d "
	(( $hours > 0 )) && echo -n "${hours}h "
	(( $minutes > 0 )) && echo -n "${minutes}m "
	echo "${seconds}s"
}

# check if repo is dirty (files untracked, unstaged, staged) and if HEAD is ahead or behind
prompt_pure_git_status () {
	# shows the full path in the title
	print -Pn '\e]0;%~\a'

	local _s=
	local local_status=
	local remote_status=

	local symbol_ahead="⇡"
	local symbol_behind="⇣"
	local symbol_status="*"

	# git status to retrieve infos
	_s=$(command git status --porcelain -b --ignore-submodules=dirty 2>/dev/null)

	# untracked
	[[ -n $(echo "$_s" | grep '^?? ' 2> /dev/null) ]] &&
		local_status="%F{yellow}$symbol_status%f"
	# unstaged
	[[ -n $(echo "$_s" | grep '^.[MTD] ' 2> /dev/null) ]] &&
		local_status="${local_status}%F{red}$symbol_status%f"
	# staged
	[[ -n $(echo "$_s" | grep '^[AMRD]. ' 2> /dev/null) ]] &&
		local_status="${local_status}%F{green}$symbol_status%f"

	# ahead
	[[ -n $(echo "$_s" | grep '^## .*ahead' 2> /dev/null) ]] &&
		remote_status="%F{cyan} $symbol_ahead %f"

	# behind
	[[ -n $(echo "$_s" | grep '^## .*behind' 2> /dev/null) ]] &&
		remote_status="${remote_status}%F{cyan} $symbol_behind %f"

	echo "${local_status} ${remote_status}"
}

# displays the exec time of the last command if set threshold was exceeded
prompt_pure_cmd_exec_time() {
	local stop=$(date +%s)
	local start=${cmd_timestamp:-$stop}
	integer elapsed=$stop-$start
	(($elapsed > ${PURE_CMD_MAX_EXEC_TIME:=5})) && prompt_pure_human_time $elapsed
}

prompt_pure_preexec() {
	cmd_timestamp=$(date +%s)

	# shows the current dir and executed command in the title when a process is active
	print -Pn "\e]0;"
	echo -nE "$PWD:t: $2"
	print -Pn "\a"
}

# string length ignoring ansi escapes
prompt_pure_string_length() {
	echo ${#${(S%%)1//(\%([KF1]|)\{*\}|\%[Bbkf])}}
}

prompt_pure_precmd() {
	# shows the full path in the title
	local current_path='\e]0;%~\a'
	print -Pn $current_path

	# git info
	vcs_info

	dm_storage=$(echo "$MACHINE_STORAGE_PATH" | sed "s|.*/||")

	# show [docker-machine:<name>] if eval $(docker-machine env <name>)
	[[ "$MACHINE_STORAGE_PATH" != '' ]] && \
		prompt_pure_username="[%F{yellow}machines%f:%F{cyan}$dm_storage%f]"

	# show [docker-machine:<name>] if eval $(docker-machine env <name>)
	[[ "$DOCKER_MACHINE_NAME" != '' ]] && \
		prompt_pure_username="[%F{yellow}machines%f:%F{cyan}$dm_storage%f] [%F{yellow}machine%f:%F{green}$DOCKER_MACHINE_NAME%f]"

	local prompt_pure_preprompt='\n%{$FG[033]%}%~%F{white}$vcs_info_msg_0_%f `prompt_pure_git_status` $prompt_pure_username%f %n@%m in %F{red}dops%f '$WORK_DIR' %F{yellow}`prompt_pure_cmd_exec_time`%f'
	print -P $prompt_pure_preprompt

	# check async if there is anything to pull
	# (( ${PURE_GIT_PULL:-1} )) && {
	#  	# check if we're in a git repo
	#  	command git rev-parse --is-inside-work-tree &>/dev/null &&
	#  	# check check if there is anything to pull
	#  	command git fetch &>/dev/null #&&
	# # 	# check if there is an upstream configured for this branch
	# # 	command git rev-parse --abbrev-ref @'{u}' &>/dev/null &&
	# # 	(( $(command git rev-list --right-only --count HEAD...@'{u}' 2>/dev/null) > 0 )) &&
	# # 	# some crazy ansi magic to inject the symbol into the previous line
	# # 	print -Pn "\e7\e[A\e[1G\e[`prompt_pure_string_length $prompt_pure_preprompt`C%F{cyan}⇣%f\e8"
	# } &!

	# reset value since `preexec` isn't always triggered
	unset cmd_timestamp
}

prompt_pure_setup() {
	# prevent percentage showing up
	# if output doesn't end with a newline
	export PROMPT_EOL_MARK=''

	prompt_opts=(cr subst percent)

	autoload -Uz add-zsh-hook
	autoload -Uz vcs_info

	add-zsh-hook precmd prompt_pure_precmd
	add-zsh-hook preexec prompt_pure_preexec

	zstyle ':vcs_info:*' enable git
	zstyle ':vcs_info:git*' formats ' %b'
	zstyle ':vcs_info:git*' actionformats ' %b|%a'

	# show username@host if logged in through SSH
	[[ "$SSH_CONNECTION" != '' ]] && prompt_pure_username='%n@%m '

	# prompt turns red if the previous command didn't exit with 0
	PROMPT='%(?.%F{magenta}.%F{red})>%f '
}

prompt_pure_setup "$@"
