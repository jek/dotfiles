(setq tab-always-indent t)

(setq auth-sources '("~/.netrc"))

(prefer-coding-system 'utf-8)

(setq truncate-lines nil)

(with-eval-after-load 'spaceline-segments
  (spaceline-toggle-minor-modes-off)
  (spaceline-toggle-buffer-size-off))

(setq sqlfmt-executable "pg_format")
(setq sqlfmt-options '())

(provide 'jek-base-custom)
