# -*- mode: shell-script; coding: utf-8;  -*-
# .bashrc
# <jek@discorporate.us>

if [[ $(uname -s) == "Darwin" ]]; then
    DARWIN=t
else
    LINUX=t
fi

if [ "$EMACS" = t ]; then
    export PS1='\u:\W\$ '
    export PS2='\u:\W\$\$ '
else
    export PS1="\h:\w\$ "
    export PS2='> '
fi

set -o emacs
export command_oriented_history=1
export history_control=ignoredups
export no_exit_on_failed_exec=1
export IGNOREEOF=0

export PAGER=less
export MANPAGER="less -C -e +Gg -P?f%f:''.'--('?pb%pb:'0'.'\%'?lb' line '%lb.')--'"

if [[ $LINUX ]]; then
    alias ls='ls -F --color=auto'
    eval $(dircolors)
fi

if [[ $DARWIN ]]; then
    export CLICOLOR=1

    alias open="DYLD_LIBRARY_PATH= /usr/bin/open"
fi

export GRIN_ARGS="-C 2 -d junk -e .pyc,.pyo,.so,.o,.a,.tgz,.pot,.po,.mo"
function pgrin() {
    grin --force-color $* | less -RX
}

function pgps() {
    echo "select procpid,usename,current_query,waiting from pg_stat_activity" |\
      psql i3
}

function pgkill() {
    echo "select pg_cancel_backend($1);" | psql ${2:-i3}
}

function pyi () {
    PYTHONSTARTUP=${HOME}/.pyi.rc python -i "$@"
}

function pymp () {
    python -c "import $1"
}

function pgpyflakes () {
    pyflakes `hg pexport $* | \
              fgrep '+++ b/' | cut -f 1 | cut -c 7- | \
              sort | uniq`
}

alias idev='exec ssh idev'

function _family() {
    if [[ $sandbox_family ]]; then
        echo "${sandbox_family} "
    fi
}

function _if_err() {
    local ok=${1}
    local notok=${2}
    echo -n "\$(if ([[ \$? -eq 0 ]]) then "
    echo -n "echo \"${ok}\"; "
    echo -n "else "
    echo -n "echo \"${notok}\";"
    echo -n "fi)"
}

_reset=$(tput sgr0)
if ([[ $DARWIN ]]) then
  _err_or_white=$(_if_err "\e[0;37m" "\e[0;31m")
else
  _err_or_white=$(_if_err "\e[0;36m" "\e[0;31m")
fi
_bang_err=$(_if_err " " "!")

function _vcprompt() {
    vcprompt -f $' at \033[33m%b \033[1;36m%u%m\033[0m'
}

function codeprompt() {
    if [[ ${sandbox_family} == "i4" ]]; then
        export PS1="${_err_or_white}<$(_family)\w>\e[0m\$(_vcprompt)${_reset}\n\\$ "
    else
        export PS1="${_err_or_white}<$(_family)\w>\e[0m\$(_vcprompt) \e[1;33m⚡\e[0m\$(basename \${VIRTUAL_ENV:-sys})${_reset}\n\\$ "
    fi
}


function oss() {
    venv=${1:-default}
    if ([[ $VIRTUAL_ENV ]]) then
        deactivate
    fi
    source ~/projects/oss/envs/${venv}/bin/activate
    export sandbox_family=oss
    codeprompt
    if [[ `pwd` != $HOME/projects/oss/* ]]; then
        cd ~/projects/oss/src
        [[ -e ${venv}-main ]] && cd ${venv}-main
    fi
}
function _complete_oss()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "`/bin/ls ~/projects/oss/envs`" -- ${cur}) )
}
complete -F _complete_oss oss


function i3() {
    export PATH=$PATH:/idealist/sbin
    cd ~/work/
    export sandbox_family=i3
    codeprompt

    function i3on {
        local cur_ps1=${PS1}
        if [ -e bin/activate ]; then
            source bin/activate;
        else
            /idealist/sandbox/bin/paver environment
            source bin/activate;
        fi
        export PS1=${cur_ps1}
        settitle "i3:$(basename `pwd`)"
        function i3off () {
            settitle i3
            deactivate
        }
    }

    # run server fast
    alias rsf='bin/invoke idealist.webapp.utilities.run_werkzeug_server --mode=dev --reloader=0 --threaded=0'

    # land in the most recently used ido branch
    for d in `/bin/ls -1td ./ido*`; do
        if [ -e $d/setup.py ]; then
            cd $d;
            break;
        fi
    done
    source /idealist/releases/sandbox-v$(make -s sandbox-version)/bin/activate.sh
    settitle i3
    settabcolor 10 108 135
}


function i4() {
    export PATH=$PATH:/idealist/sbin
    cd ~/work/
    export sandbox_family=i4
    codeprompt

    function i4on {
        local cur_ps1=${PS1}
        source develop
        settitle "i4:$(basename `pwd`)"
    }

    # land in the most recently used ido branch
    for d in `/bin/ls -1td ./i4*`; do
        if [ -e $d/setup.py ]; then
            cd $d;
            break;
        fi
    done
    source /idealist/releases/sandbox-v$(make -s sandbox-version)/bin/activate.sh
    settitle i4
    settabcolor 232 180 23
}


### Fancy X11 terminal support
##  A collection of functions to auto-set helpful reminders in the
##  title bar and icon name.  Supports rlogin, telnet. su and ssh as
##  well.
##
##  Currently only checks for XWsh and xterm- there may be other
##  terminal programs which support the titlebar escapes.
if [ `echo $TERM | cut -c1-4` = "iris" -o $TERM = "xterm" -o $TERM = "xterm-color" -o $TERM = "xterm-256color" ] ; then

  export PS1="(\h)${_bang_err}\W\$ "

  # window title setting routine
  function settitle {
    export WIN_NAME="$*"
    echo -n "]1;$*"
    echo -n "]2;$*"
    echo -ne "\033]0;$*\007"
  }

  function settabcolor {
      echo -ne "\033]6;1;bg;red;brightness;$1\a"
      echo -ne "\033]6;1;bg;green;brightness;$2\a"
      echo -ne "\033]6;1;bg;blue;brightness;$3\a"
  }

  # set the default name
  export WIN_NAME=`uname -n`
  settitle $WIN_NAME

  function su {
    local OLD_WIN_NAME=$WIN_NAME
    local username
    if [ $2 ]; then
      username=$2
    elif [ $1 ]; then
      if [ $1 = '-' ]; then
        username='root'
      else
        username=$1
      fi
    else
      username='root'
    fi
    settitle "$username@`hostname`"
    command su $*
    settitle "$OLD_WIN_NAME"
  }

  # ssh is too complicated for flag parsing.
  function ssh {
    local OLD_WIN_NAME=$WIN_NAME
    settitle "ssh $*"
    command ssh $*
    settitle "$OLD_WIN_NAME"
  }

  # less
  function less {
    local OLD_WIN_NAME=$WIN_NAME
    settitle "less: $*"
    command less $*
    settitle "$OLD_WIN_NAME"
  }

  # man
  function man {
    local OLD_WIN_NAME=$WIN_NAME
	settitle "man: $*"
	command man $*
	settitle "$OLD_WIN_NAME"
  }

  # pydoc
  function pydoc {
    local OLD_WIN_NAME=$WIN_NAME
	settitle "pydoc: $*"
	command pydoc $*
	settitle "$OLD_WIN_NAME"
  }

  # Alternative, auto-updating titlebar.
  function changetitle() {
    export PS1='\[[1m[4m\]\W\[[0m]1;\]\u@\h \w\[]2;\]\u@\h \w\[\]\$ '
  }

  settitle $(hostname)
else
  function settitle {
    export WIN_NAME="$*"
  }

  function settabcolor {
      return
  }
fi
###


# Path cleaner: strip out blanks and non-existent dirs; always pass
# thru relative dirs; for absolute, only use the first instance,
# counting physically (by inode)
function echo3 {
    echo $3
}
function pathclean {
    local cmd
    if which perl >/dev/null; then
      cmd=perl
    else
      cmd=echo3
    fi
    $cmd -e '@path=split(/:/, $ARGV[0]); foreach (@path) {next unless $_; if (m:^/:) {next unless -d || -l; $id=join("/", (stat _)[1..2])} else {$id=$_} unless ($path{$id}) {s:(.)/$:$1:; $path{$id}=$_; push(@final, $_);}} print join(":", @final), "\n"' $1
}

# CLASSPATH cleaner: like pathclean, but allows jar files as well.
function classpathclean {
    local cmd
    if which perl >/dev/null; then
      cmd=perl
    else
      cmd=echo3
    fi
    $cmd -e '@path=split(/:/, $ARGV[0]); foreach (@path) {next unless $_; if (m:^/:) { next unless -f || -d || -l; next if -f && not m:jar$:; $id=join("/", (stat _)[1..2])} else {$id=$_} unless ($path{$id}) {s:(.)/$:$1:; $path{$id}=$_; push(@final, $_);}} print join(":", @final), "\n"' $1
}

function jarcollector {
  local jarpath
  for i in $*; do
    local jars
    jars=`find $i -type f -name '*.jar' 2>/dev/null`;
    if [ "x$jars" != "x" ]; then
      jarpath=$jarpath:`echo $jars | perl -0777ane '$,=":";print @F'`
    fi
  done
  classpathclean $jarpath
}
