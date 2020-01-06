(defconst jek-windowing-packages
  '(
    company
    yequake
    (jek-windowing-custom :location local)
    ))

(defun jek-windowing/post-init-company ()
  (use-package company
    :config
    (setq company-emoji-insert-unicode t)
    ))

(defun jek-windowing/init-yequake ()
  (use-package yequake
    :config
    (setq yequake-frames
          '(("org-capture" .
             ((buffer-fns . (yequake-org-capture))
              (width . 0.75)
              (height . 0.5)
              (alpha . 0.95)
              (frame-parameters . ((undecorated . t)
                                   (skip-taskbar . t)
                                   (sticky . t)))))
            ("org" .
             ((buffer-fns . (;"~/org/inbox.org"
                             org-ql-view-sidebar))
              (width . 0.9)
              (height . 0.8)
              (alpha . 0.95)
              (frame-parameters . ((undecorated . t)
                                   (skip-taskbar . t)
                                   (sticky . t)))))
            ("demo" .
             ((width . 0.75)
              (height . 0.5)
              (alpha . 0.95)
              (buffer-fns . ("~/org/inbox.org"
                             (lambda ()
                               (or (get-buffer "*Org Agenda*")
                                   (save-excursion
                                     (org-agenda-list)
                                     (current-buffer))))
                             org-now
                             ))
              (frame-parameters . ((undecorated . t))))
             )))
    ))

(defun jek-windowing/init-jek-windowing-custom ()
  (use-package jek-windowing-custom
    ))
