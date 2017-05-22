# -*- mode: shell-script; coding: utf-8;  -*-
# .bashrc
# <jek@discorporate.us>

if [[ $(uname -s) == "Darwin" ]]; then
    DARWIN=t
else
    LINUX=t
fi

if [[ $LINUX ]]; then
    alias ls='ls -F --color=auto'
    eval $(dircolors)
fi

if [[ $DARWIN ]]; then
    export CLICOLOR=1
    alias open="DYLD_LIBRARY_PATH= /usr/bin/open"
fi

set -o emacs
export command_oriented_history=1
export history_control=ignoredups
export no_exit_on_failed_exec=1
export IGNOREEOF=0

if [ "$EMACS" = t ]; then
    export PS1='\u:\W\$ '
    export PS2='\u:\W\$\$ '
else
    export PS1="\h:\w\$ "
    export PS2='> '
fi

export EDITOR=$HOME/bin/editwait
export VISUAL=$HOME/bin/editwait
export SVNEDITOR=$HOME/bin/editin
export BZR_EDITOR=$HOME/bin/editwait

export PAGER=less
export MANPAGER="less -C -e +Gg -P?f%f:''.'--('?pb%pb:'0'.'\%'?lb' line '%lb.')--'"

export LS_COLORS='no=00:fi=00:di=04;34:ln=04;37:pi=30;44;07:so=30;41;07:bd=30;42;07:cd=30;43;07:ex=00;31:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;35:*.deb=00;31:';



if [ -d ~/.bashrc.d ]; then
    for f in ~/.bashrc.d/*.sh; do
        if [[ $f != "host-*" ]]; then
            # XXX echo $f
            source $f;
        fi
    done
    if [ -e ~/.bashrc.d/host-$(hostname -s).sh ]; then
        source ~/.bashrc.d/host-$(hostname -s).sh
    fi
fi
