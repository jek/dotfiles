function pyi () {
    PYTHONSTARTUP=${HOME}/.config/pyi/pyi.rc python -i "$@"
}

function pymp () {
    python -c "import $1"
}
