### Fancy X11 terminal support
##  A collection of functions to auto-set helpful reminders in the
##  title bar and icon name.  Supports rlogin, telnet. su and ssh as
##  well.
##
##  Currently only checks for XWsh and xterm- there may be other
##  terminal programs which support the titlebar escapes.
if [ $TERM = "xterm" -o $TERM = "xterm-color" -o $TERM = "xterm-256color" ] ; then

  export PS1="(\h)${_bang_err}\W\$ "

  # window title setting routine
  function settitle {
    export WIN_NAME="$*"
    echo -n "]1;$*"
    echo -n "]2;$*"
    echo -ne "\033]0;$*\007"
  }

  function settabcolor {
      if ([[ $1 == 'blue' ]]) then
          _settabcolor 2 140 135;
      elif ([[ $1 == 'yellow' ]]) then
          _settabcolor 255 208 4;
      elif ([[ $1 == 'green' ]]) then
          _settabcolor 122 187 62;
      elif ([[ $1 == 'orange' ]]) then
          _settabcolor 250 120 0;
      else
          _settabcolor $1 $2 $3;
      fi
  }

  function _settabcolor {
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
  if ([[ $LINUX ]]) then
      settabcolor yellow
  fi
else
  function settitle {
    export WIN_NAME="$*"
  }

  function settabcolor {
      return
  }
fi

