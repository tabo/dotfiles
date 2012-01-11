#!/bin/sh
#
# .profile
#
# Gustavo Picon - 1999-2009
#
# This works with bash, zsh, pdksh, ksh88, ksh93, ash, dash, sh
# in OS X, RHEL, FreeBSD, OpenBSD, SunOS, Solaris, HP-UX  and Ubuntu
#
# Sets some basic aliases, a valid PATH env for every host (no non-existant
# dirs), some sane env vars, and a nice looking PS1/PROMPT, using the best
# available method for every shell. It will also set the xterm title when
# possible.
#
# Add your local scripts in ~/.local/bin
# You can add more settings in ~/.local/profile
#
# Get the last version in http://code.tabo.pe/dotfiles/src/tip/.profile


umask 022

alias df='df -h'
alias du='du -h'
alias f='finger'
alias h='history'
alias j='jobs -l'
alias ls='ls -F'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

# set the $PATH env, it will add only directories that actually exist in the
# system, so it's safe to add more and more dirs to the array
PATH=""
set_path() {
    for d in $@; do
        if [ -d $d ]; then
            if [ "$PATH" != "" ]; then
                PATH=$PATH:$d
            else
                PATH=$d
            fi
        fi
    done
}
set_path $HOME/bin $HOME/.local/bin \
         /opt/local/sbin /opt/local/bin /usr/gnu/bin \
         /ffp/sbin /ffp/bin \
         /sbin /bin \
         /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin \
         /usr/X11/bin /usr/games \
         /usr/usb /usr/opt/bin /usr/pkg/sbin /usr/pkg/bin

# alternates function STOLEN from Zak Johnson ;)
alternates() {
    for i in $*; do
        type $i >/dev/null 2>&1 && echo $i && return
    done
}
EDITOR=$(alternates vim vi)
PAGER=$(alternates less more)
LESS=gi
HISTCONTROL=ignoreboth
BLOCKSIZE=K
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8



export PATH EDITOR PAGER LESS HISTCONTROL LC_ALL LANG BLOCKSIZE


# end non-interactive section
[ -z "$PS1" ] && [ -z "$PROMPT" ] && return

#
# interactive sessions
#

# why sed instead of awk or cut? because sed will work in busybox ;)
shostname=$(hostname | sed 's/\..*//g')
shwhoami=$(whoami)
shuid=$(id -u)

# just in case what follows FAILS (like some versions of busybox)
PS1=${shwhoami}'@'${shostname}':\W\$ '
#PS1="]0;"${shwhoami}"@"${shostname}':\w'"${PS1}"
export PS1


# identifying the shell type
# based on a snippet by Cyrille Lefevre
# https://mailman.research.att.com/pipermail/ast-users/2008q3/002204.html
# Added better korn shell detection and made it POSIX compliant
# Also added quick&dirty busybox detection
if ( [ -n "${BASH_VERSION:-}" ] )
then
    is='bash'
elif ( [ -n "${KSH_VERSION:-}" ] )
then
    is='pdksh'
elif ( [ -n "${ZSH_VERSION:-}" ] )
then
    is='zsh'
#
# Uncomment the next block to enable ksh detection
# I don't use ksh, and the "${.sh.version}" check isn't standard
# compliant, so it breaks some basic and/or old bourne shells.
#
###
#elif ( [ -n "${.sh.version}" ] ) 2>&-
#then
#    if [[ ${SECONDS:-} = *'.'* ]]
#    then
#        is='ksh93'
#    else
#        is='ksh88'
#    fi
###
else
    # fallback
    is='sh'
fi


if [ $is = 'bash' ] || [ $is = 'pdksh' ]
then

    if [ $(id -u) -eq 0 ]
    then
        PS1='\h:\W\$ '
    else
        PS1='\u@\h:\W\$ '
    fi

    case "$TERM" in
    xterm*|rxvt*|screen*)
        PS1="\[]0;\u@\h:\w\]${PS1}"
        ;;
    *)
        ;;
    esac

    if [ $is = 'bash' ]
    then

        # check the window size after each command and, if necessary,
        # update the values of LINES and COLUMNS.
        shopt -s checkwinsize

        # this is a cool feature in ubuntu
        if [ -f /etc/bash_completion ]
        then
            . /etc/bash_completion
        fi
    fi
    export PS1

elif [ $is = 'zsh' ]
then
    PROMPT='%n@%m:%c%# '

    case "$TERM" in
    xterm*|rxvt*|screen*)
        precmd () {
            print -Pn "\e]0;%n@%m:%~\a"
        }
        ;;
    *)
        ;;
    esac

    export PROMPT
elif ( [ "$is" = 'ksh88' ] || [ "$is" = 'ksh93' ] )
then
    # universal $PS1


    if ( [ "$shuid" = "0" ] )
    then
        #PS1=${shostname}':${PWD/${HOME}/\~}# '
        PS1=${shostname}':${PWD##*/}# '
    else
        PS1=${shwhoami}'@'${shostname}':${PWD##*/}\$ '
    fi
    PS1="$PS1 $is"

    case "$TERM" in
    xterm*|rxvt*|screen*)
        PS1="]0;"${shwhoami}"@"${shostname}':${PWD/${HOME}/\~}'"${PS1}"
        ;;
    *)
        ;;
    esac

    export PS1
else
    # sh... possibly ash (bsd, busybox) or dash (ubuntu)

    if ( [ "$shuid" = "0" ] )
    then
        PS1=${shostname}':${PWD}# '
    else
        PS1=${shwhoami}'@'${shostname}':${PWD}\$ '
    fi

    case "$TERM" in
    xterm*|rxvt*|screen*)
        PS1="]0;"${shwhoami}"@"${shostname}':${PWD}'"${PS1}"
        ;;
    *)
        ;;
    esac

fi

unset shostname shwhoami shuid

if [ -f "$HOME/.local/profile" ]; then
    . "$HOME/.local/profile"
fi
