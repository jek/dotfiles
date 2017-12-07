if which -s ag; then
  alias pag='ag --pager "less -R"'
fi

if which -s grin; then
  export GRIN_ARGS="-C 2 -d junk -e .pyc,.pyo,.so,.o,.a,.tgz,.pot,.po,.mo"
  function pgrin() {
    grin --force-color $* | less -RX
  }
fi
