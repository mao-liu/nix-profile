# .bash_profile

export BASH_PROFILE_LOADED=$0

# Get the aliases and functions
if [ -z $BASHRC_LOADED ] && [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# are there more local configurations?
if [ -z $BASH_PROFILE_LOCAL_LOADED ] && [ -f .bash_profile.local ]; then
    . ~/.bash_profile.local
fi

# Launch ssh-agent
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
     echo "Initialising new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     #ps ${SSH_AGENT_PID} doesn't work under cywgin
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
         start_agent;
     }
else
     start_agent;
fi 

# add the id_rsa identity to ssh-agent if it is not already added
ssh-add -l > /dev/null || ssh-add

# User specific environment and startup programs
[[ ! `alias rm` ]] 2>/dev/null && alias rm="rm -v"
[[ ! `alias mv` ]] 2>/dev/null && alias mv="mv -v"
[[ ! `alias htop` ]] 2>/dev/null && alias htop="sudo htop"
[[ ! `alias myhtop` ]] 2>/dev/null && alias myhtop="htop -u myliu"
[[ ! `alias ssh` ]] 2>/dev/null && alias ssh="ssh -Y"
[[ ! `alias vi` ]] 2>/dev/null && alias vi="vim"

export EDITOR=vim

[[ ! $PATH == *"$HOME/bin"* ]] && PATH=$PATH:$HOME/bin
[[ ! $PATH == *"/usr/local/bin"* ]] && PATH=/usr/local/bin:$PATH
[[ ! $PATH == *"/usr/local/sbin"* ]] && PATH=/usr/local/sbin:$PATH
export PATH

[[ ! $PYTHONPATH == *"$HOME/code"* ]] && PYTHONPATH=$HOME/code:$PYTHONPATH
[[ ! $PYTHONPATH == *"/usr/local/lib"* ]] && PYTHONPATH=/usr/local/lib:$PYTHONPATH
export PYTHONPATH

export GNUTERM='x11'

unset BASH_PROFILE_LOADED
