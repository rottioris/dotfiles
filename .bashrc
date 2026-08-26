#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
eval "$(mise activate bash)"

export PATH="$HOME/bin:$PATH"

OCI_AC="$HOME/lib/oracle-cli/lib/python3.14/site-packages/oci_cli/bin/oci_autocomplete.sh"
[[ -e "$OCI_AC" ]] && source "$OCI_AC"
