# -*- shell-script-mode -*-
# .bash_profile
# <jek@discorporate.us>

[[ $UID = 0 ]] && exit

if [ -z "$ENVONLY" ]
then
    [[ -t 0 ]] && stty intr '^C' susp '^Z' echoe
fi

if which keychain 2>&1 >/dev/null; then
  keychain -q ~/.ssh/id_???
fi

umask 002
if ([[ $MACHTYPE = x86_64-apple-darwin10.0 ]]) then
  ulimit -n 2048
fi

[[ -e ~/.bashrc ]] && . ~/.bashrc

export EDITOR=$HOME/bin/editwait
export VISUAL=$HOME/bin/editwait
export SVNEDITOR=$HOME/bin/editin
export BZR_EDITOR=$HOME/bin/editwait

export CDPATH=.
export LS_COLORS='no=00:fi=00:di=04;34:ln=04;37:pi=30;44;07:so=30;41;07:bd=30;42;07:cd=30;43;07:ex=00;31:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;35:*.deb=00;31:';

export PATH=`pathclean \
.:$HOME/bin\
:$HOME/.gem/ruby/1.8/bin\
:/opt/local/bin\
:$JAVA_HOME/bin\
:/usr/etc:/usr/sbin\
:/usr/ccs/bin:/opt/bin:/usr/bin\
:/usr/local/bin\
:/sbin:/usr/sbin:/usr/local/sbin:/etc:/usr/etc\
:$PATH`

## Set MANPATH
export MANPATH=`pathclean \
.:~/lib/man\
:/opt/local/share/man\
:/usr/local/share/man:/usr/local/man\
:/usr/man:/usr/catman:/usr/share/man\
:/usr/X11R6/man\
:$MANPATH`

if [ -f /opt/local/etc/bash_completion ]; then
  . /opt/local/etc/bash_completion
fi
