# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
function cyan_red_prompt
{
  local CYAN="\[\033[0;36m\]"
  local GRAY="\[\033[0;37m\]"
  local RED="\[\033[0;31m\]"
  local BLACK="\[\033[0m\]"

  PS1="${CYAN}[${BLACK}\t ${RED}#\# ${BLACK}\u${RED}@${CYAN}\H:${RED}\w/${CYAN}]"'\n'"${BLACK}\s ${BLACK}\$ "
}

cyan_red_prompt

