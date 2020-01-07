(setq custom-file "~/.emacs.d/private/custom.el")
(load custom-file)

(setq tab-always-indent t)

(prefer-coding-system 'utf-8)

(setq truncate-lines nil)

(with-eval-after-load 'spaceline-segments
  (spaceline-toggle-minor-modes-off)
  (spaceline-toggle-buffer-size-off))

(setq sqlfmt-executable "pg_format")
(setq sqlfmt-options '())

(provide 'jek-base-custom)
