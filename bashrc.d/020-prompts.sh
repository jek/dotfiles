
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
    export PS1="${_err_or_white}<$(_family)\w>\e[0m\$(_vcprompt) \e[1;33m⚡\e[0m\$(basename \${VIRTUAL_ENV:-sys})${_reset}\n\\$ "
}
