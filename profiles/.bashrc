# .bashrc

export BASHRC_LOADED=$0

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# a simple prompt
function simple_prompt
{
    local CYAN="\[\033[0;36m\]"
    local GRAY="\[\033[0;37m\]"
    local RED="\[\033[0;31m\]"
    local BLACK="\[\033[0m\]"

    local PROMPT="${CYAN}[${BLACK}\t ${RED}#\# ${BLACK}\u${RED}@${CYAN}\H:${RED}\w/${CYAN}]"'\n'
    PROMPT="${PROMPT}${BLACK}\s ${BLACK}\$ "
    PS1="${PROMPT}"
}

# a more complex prompt which shows execution times and exit codes
function timer_start {
    timer=${timer-`date +%s%3N`}
}
function timer_stop {
    local end=`date +%s%3N`
    timer_show=`echo "scale=3; (${end} - ${timer})/1000" | bc`
    unset timer
}
function bracket_prompt
{
    local CYAN="\[\033[0;36m\]"
    local GRAY="\[\033[0;37m\]"
    local RED="\[\033[0;31m\]"
    local BLACK="\[\033[0m\]"

    if [[ $STY ]]; then
        CYAN="\[\033[0;35m\]"       # change to pink if it is a screen
    elif [[ $SSH_TTY ]]; then
        CYAN="\[\033[0;32m\]"       # change to green if it is SSH-interactive
    elif [[ $SHLVL -gt 1 ]]; then
        CYAN="\[\033[0;34m\]"       # change to blue if it is an interactive shell many levels deep
    fi

    local BRACEOPEN="\342\224\214\342\224\200\342\224\200"
    local BRACECLOSE="\342\224\224\342\224\200\342\224\200"
    local LINE="\342\224\200\342\224\200"

    trap 'timer_start' DEBUG
    PROMPT_COMMAND=timer_stop

    local DEFAULT_PY=`which python`

    local PROMPT="${CYAN}${BRACECLOSE}"
    PROMPT="${PROMPT}[${GRAY}exit status${RED}: ${BLACK}\$?${CYAN}]$LINE"
    PROMPT="${PROMPT}[${GRAY}time completed${RED}: ${BLACK}\t${CYAN}]$LINE"
    PROMPT="${PROMPT}[${GRAY}time elapsed${RED}: ${BLACK}\${timer_show}${RED}s${CYAN}]$LINE"
    PROMPT="${PROMPT}"'\n\n\n'
    PROMPT="${PROMPT}${CYAN}${BRACEOPEN}"
    PROMPT="${PROMPT}[${GRAY}${platform}-\s${CYAN}]${LINE}"
    PROMPT="${PROMPT}[${GRAY}\$( which python )${CYAN}]${LINE}"
    PROMPT="${PROMPT}"'\n'
    PROMPT="${PROMPT}${CYAN}${BRACEOPEN}"
    PROMPT="${PROMPT}[${RED}#\#${CYAN}]$LINE"
    PROMPT="${PROMPT}[${BLACK}\u${RED}@${BLACK}\H${RED}:${GRAY}\w/${CYAN}]${LINE}"
    PROMPT="${PROMPT}"'\n'"${GRAY}\$ ${BLACK}"
  
    PS1="${PROMPT}"
}

nest_level=1
if [[ $STY ]]; then
    nest_level=2
fi
platform=""
[[ $SHLVL -gt $nest_level ]] && platform="nested-$((${SHLVL}-${nest_level}))-${platform}"
[[ $STY ]] && platform="screen-${platform}"
[[ $SSH_TTY ]] && platform="SSH-${platform}"
unset nest_level

# determine the OS environment, then set up aliases
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    platform="${platform}Linux"
    bracket_prompt
elif [[ "$OSTYPE" == "darwin"* ]]; then
    platform="${platform}OSX"
    # brew/coreutils installs GNU binaries on OSX
    # these are accessed using the 'g' prefix
    [[ `which gdircolors` ]] && eval `gdircolors`
    [[ `which gls` ]] && alias ls="gls --color"
    [[ `which gecho` ]] && alias echo="gecho"
    [[ `which gmktemp` ]] && alias mktemp="gmktemp"
    if [[ `which gdate` ]]; then
        alias date="gdate"
        bracket_prompt
    else
        # if GNU binaries aren't installed, use the simple prompt
        simple_prompt
    fi
#elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
#elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
#elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
else
    platform="${platform}Unknown"
    simple_prompt
fi

# Load RVM if it exists
function rvm_start {
    source "$HOME/.rvm/scripts/rvm"
    rvm use 1.9.3 > /dev/null
    PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
}
[[ ! $PATH == *"$HOME/.rvm/bin"* ]] && [[ -s "$HOME/.rvm/scripts/rvm" ]] && rvm_start
export PATH

if [ -z $BASH_PROFILE_LOADED ] && [ -f ~/.bash_profile ]; then
    . ~/.bash_profile
fi

unset BASHRC_LOADED
