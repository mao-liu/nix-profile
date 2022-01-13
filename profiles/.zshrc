setopt BASH_REMATCH

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
autoload -U colors && colors

function prompt_colour
{
    local color=$1
    local str="${@:2}"

    echo "%{$fg[$color]%}"$str"%{$reset_color%}"
}

function set_prompt
{
    local left_brace=`prompt_colour cyan [`
    local right_brace=`prompt_colour cyan ]`
    local newline=$'\n'
    local box_nw=$'\u250c\u2500'
    local box_sw=$'\u2514\u2500'

    local time="%*"
    local exec_num=`prompt_colour red "#%h"`
    local user="%n"
    local at=`prompt_colour red "@"`
    local host=`prompt_colour cyan "%m:"`
    local path=`prompt_colour red "%~/"`
    local cursor="zsh %# "
    local retval=$'\u27f6'"  %?"

    local top="${box_nw}${left_brace}${time} ${user}${at}${host}:${path}${right_brace}"
    local bottom="${box_sw}${left_brace}${exec_num}${retval}${right_brace}"

    local hrule="%U${(r:$COLUMNS:: :)}%u${newline}"

    PROMPT="${bottom}${newline}${hrule}${newline}${top}${top_fill}${newline}${cursor}"
}
set_prompt

source ~/.profile

