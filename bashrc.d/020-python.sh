if which -s pyenv; then
    export PATH="~/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
fi

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

export GRIN_ARGS="-C 2 -d junk -e .pyc,.pyo,.so,.o,.a,.tgz,.pot,.po,.mo"
function pgrin() {
    grin --force-color $* | less -RX
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
