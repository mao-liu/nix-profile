export EDITOR=vim

export GNUTERM='x11'

eval `gdircolors`

alias make="gmake"
alias ls="gls --color"
alias echo="gecho"
alias git-history="git log --graph --pretty=oneline --abbrev-commit --branches"
alias git-clean="git fetch --prune && (git branch | egrep -v '(master|develop|\*)' | xargs git branch -d)"
alias ssh-tunnel="ssh -t -D 1080"
alias pytest="pytest --ff --pdb --cov . --cov-report term-missing -x"
alias rm="rm -v"
alias mv="mv -v"

SSH_ENV="$HOME/.ssh/environment"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

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

function ecr-login {
    eval `aws ecr get-login --no-include-email --profile default`
}

function github {
    remote_url=`git config --get remote.origin.url`
    if [[ $remote_url != "https://"* ]]; then
        remote_url=`git config --get remote.origin.url | sed 's/:/\//' | sed 's/git@/https:\/\//'`
    fi
    open $remote_url
}

export SAM_CLI_TELEMETRY=0
