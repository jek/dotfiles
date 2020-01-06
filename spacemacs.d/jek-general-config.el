;; based on https://github.com/fabrik42/.spacemacs.d/blob/master/config/my-general-config.el

(setq tab-always-indent t)

(setq auth-sources '("~/.netrc"))

(prefer-coding-system 'utf-8)

(setq truncate-lines nil)

(with-eval-after-load 'spaceline-segments
  (spaceline-toggle-minor-modes-off)
  (spaceline-toggle-buffer-size-off))

(setq sqlfmt-executable "pg_format")
(setq sqlfmt-options '())

(defun --set-emoji-font (frame)
  "Adjust the font settings of FRAME so Emacs can display emoji properly."
  (if (eq system-type 'darwin)
      ;; For NS/Cocoa
      (set-fontset-font t 'symbol (font-spec :family "Apple Color Emoji" :size 10) frame 'prepend)
    ;; For Linux
    (set-fontset-font t 'symbol (font-spec :family "Symbola") frame 'prepend)))

;; For when Emacs is started in GUI mode:
(--set-emoji-font nil)

;; Hook for when a frame is created with emacsclient
;; see https://www.gnu.org/software/emacs/manual/html_node/elisp/Creating-Frames.html
(add-hook 'after-make-frame-functions '--set-emoji-font)

(setq company-emoji-insert-unicode t)

(use-package ivy-posframe
  :after ivy
  :diminish
  :config
  (setq ivy-posframe-display-functions-alist
        '((swiper          . nil)
          (complete-symbol . ivy-posframe-display-at-point)
          (counsel-M-x     . ivy-posframe-display-at-window-bottom-left)
          (t . ivy-posframe-display-at-frame-center))
        ivy-posframe-height-alist '((t . 24))
        ivy-posframe-parameters
        '((internal-border-width . 6)
          (internal-border-color . "#2d3543")
          (background-color . "#212731")))
  (ivy-posframe-mode +1))

(provide 'jek-general-config)
