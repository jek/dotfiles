(defconst jek-base-packages
  '(
    all-the-icons-dired
    git-auto-commit-mode
    (jek-base-custom :location local)
    ))

(defun jek-base/init-all-the-icons-dired ()
  (use-package all-the-icons-dired
    :after all-the-icons
    :hook (dired-mode-hook . all-the-icons-dired-mode)))

(defun jek-base/init-git-auto-commit-mode ()
  (use-package git-auto-commit-mode
    :config
    (setq gac-automatically-push-p nil)
    (setq gac-automatically-add-new-files-p t)
    (setq gac-ask-for-summary-p nil)
    ))

(defun jek-base/init-jek-base-custom ()
  (use-package jek-base-custom
    ))
