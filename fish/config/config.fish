set PATH $PATH ~/.cargo/bin
set PATH $PATH ~/Library/Python/3.8/bin

if status is-interactive
    set fish_greeting

    source (/usr/local/bin/starship init fish --print-full-init | psub)

    fzf_configure_bindings --directory=\cf --history=\cr

    function pyi
        set PYTHONSTARTUP ~/.config/pyi/pyi.rc
        python3 -i $argv
    end
end
