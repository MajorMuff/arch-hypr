# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -f $HOME/.bash_aliases ]] && . $HOME/.bash_aliases

printf -v c0 "\x1b[0m"
printf -v c1 "\x1b[38;2;189;178;255m"
printf -v c2 "\x1b[38;2;255;214;165m"
b=$(tput bold)

export PS1='${b}${c1}[ ${c2}\w ${c1}] ${c2}>${c0} '

~/scripts/fetch
