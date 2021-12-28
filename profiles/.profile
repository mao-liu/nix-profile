export PROFILE_LOADED=$0

if [ -z $BASH_PROFILE_LOADED ] && [ -f ~/.bash_profile ]; then
    . ~/.bash_profile
fi

unset PROFILE_LOADED
