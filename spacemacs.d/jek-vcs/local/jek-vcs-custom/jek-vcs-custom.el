(setq-default git-magit-status-fullscreen t)
(setq magit-repository-directories
      '(("~/.dotfiles/" . 0)
        ("~/dev/" . 1)
        ("~/playground/" . 1)
        ("~/projects/" . 1)
        ("~/work/" . 1)))

(global-git-commit-mode t)

(provide 'jek-vcs-custom)
