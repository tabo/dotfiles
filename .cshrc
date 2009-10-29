#
# .cshrc
#
# Gustavo Picon - 1999-2009
#
# This works with csh/tcsh in OS X, OpenBSD and SunOS
#
# Sets some basic aliases, a valid PATH env for every host (no non-existant
# dirs), some sane env vars, and a nice looking prompt.

umask 22

alias df        df -h
alias du        du -h
alias f         finger
alias h         history
alias j         jobs -l
alias ls        ls -F

setenv BLOCKSIZE K
setenv LC_ALL en_US.UTF-8
setenv LANG en_US.UTF-8

# set the $PATH env, it will add only directories that actually exist in the
# system, so it's safe to add more and more dirs to the array
set path = ()
foreach d (~/bin ~/.local/bin \
           /opt/local/{sbin,bin} \
           /usr/gnu/bin \
           /sbin /bin \
           /usr/{sbin,bin,local/sbin,local/bin,X11R6/bin,X11/bin,games} \
           /usr/{usb,opt/bin,pkg/sbin,pkg/bin} )
    if (-d $d) then
        set path = (${path} ${d})
    endif
end

# non-interactive shells stop here
if (! $?USER || ! $?prompt) then
    exit 0
endif

# interactive shell

# File completion with ESC and ctrl+D (csh/tcsh). TAB works in tcsh.
set filec

# don't autocomplete these files
set fignore = (.o .pyc .swp)

# Remember the last 1000 commands
set history = 1000

set savehist = 1000
set mail = (/var/mail/$USER)
set host = `hostname | cut -f1 -d.`

# use less if available, else, fall back to more
set rctmp = `which less >&! /dev/null`
if (! $status) then
    setenv PAGER less
else
    setenv PAGER more
endif

# use vim if available, else, fall back to vi
set rctmp = `which vim >&! /dev/null`
if (! $status) then
    setenv EDITOR vim
else
    setenv EDITOR vi
endif

unset rctmp

if ($?tcsh) then
    set promptchars = "%#"
    set autolist = "ambiguous"
    if (`id -u` == 0) then
        set prompt="%{\033]0;%m:%~\007%}%m:%~%# "
    else
        set prompt="%{\033]0;%n@%m:%~\007%}%n@%m:%~%# "
    endif
    bindkey "^W" backward-delete-word
    bindkey -k up history-search-backward
    bindkey -k down history-search-forward
else
    # plain old csh...
    # abandon all hope for a hack-free cshrc ye who enter here
    echo -n "]0;${user}@${host}"
    if (`id -u` == 0) then
        #if (`uname` == "OpenBSD" || `uname` == "SunOS") then
            set prompt = "${host}# "
        #else
        #    set prompt = "${host}:${cwd}# "
        #endif
    else
        #if (`uname` == "OpenBSD" || `uname` == "SunOS") then
            set prompt = "${user}@${host}% "
        #else
        #    set prompt = "${user}@${host}:${cwd}% "
        #endif
    endif
    cd .
endif

# no annoyances
mesg n
