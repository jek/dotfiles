(defconst jek-ivy-packages
  '(
    ivy-posframe
    ))

(defun jek-ivy/init-ivy-posframe ()
  (use-package ivy-posframe
    :after ivy
    :diminish
    :config
    (setq ivy-posframe-display-functions-alist
          '((swiper          . nil)
            (complete-symbol . ivy-posframe-display-at-point)
            (counsel-M-x     . ivy-posframe-display-at-window-bottom-left)
            (t               . ivy-posframe-display-at-frame-center))
          ivy-posframe-height-alist '((t . 24))
          ivy-posframe-parameters
          '((internal-border-width . 4)))
    (ivy-posframe-mode +1)))
