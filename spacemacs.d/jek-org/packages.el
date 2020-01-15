(defconst jek-org-packages
  '(
    org
    org-agenda
    org-babel

    (jek-org-custom :location local)

    org-variable-pitch
    org-fancy-priorities

    org-starter
    org-starter-swiper

    org-ql
    org-super-agenda
    ivy-omni-org
    ivy-todo

    ox-tufte
    org-rich-yank
    ))

(defun jek-org/post-init-org ()
  (use-package org
    :init
    (spacemacs/set-leader-keys
      "oa" 'org-agenda
      "oc" 'org-capture
      "od" 'jek-org/daily-agenda
      "ol" 'org-store-link
      "oo" 'ivy-todo
      "ot" 'jek-org/add-todo)
    (spacemacs/set-leader-keys-for-major-mode 'org-mode
      "ir" 'org-rich-yank
      "sd" 'org-decrypt-entry
      "se" 'org-encrypt-entry)
    :config
    (doom-themes-org-config)
    (require 'org-crypt)
    (setq header-line-format " ")
    (setq org-bullets-bullet-list '("⬢" "◆" "▲" "■"))
    (setq org-crypt-disable-auto-save t)
    (setq org-crypt-key "DEAE8B55")
    (setq org-download-method 'attach)
    (setq org-edit-src-content-indentation 0)
    (setq org-ellipsis "…")
    (setq org-fontify-done-headline t)
    (setq org-fontify-quote-and-verse-blocks t)
    (setq org-fontify-whole-heading-line t)
    (setq org-hide-emphasis-markers t)
    (setq org-log-state-notes-into-drawer t)
    (setq org-outline-path-complete-in-steps nil)
    (setq org-refile-use-outline-path 'file)
    (setq org-reverse-note-order t)
    (setq org-src-fontify-natively t)
    (setq org-src-preserve-indentation t)
    (setq org-src-tab-acts-natively t)
    (setq org-startup-indented t)
    (setq org-tag-alist '(("crypt" . ?c)))
    (setq org-tags-column 0)
    (setq org-tags-exclude-from-inheritance (quote ("crypt")))

    (org-crypt-use-before-save-magic)

    (require 'org-checklist)
    (defun jek-org/after-org-mode-load ()
      (visual-line-mode 1)
      (vi-tilde-fringe-mode -1)
      ;(add-hook 'before-save-hook 'jek-org/org-id-get-create-all nil 'local)
      (buffer-face-mode 1)
      (face-remap-add-relative 'default :height 150)
      ;(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
      )
    (defun jek-org/after-org-archive ()
      (org-save-all-org-buffers))
    (defun jek-org/org-id-get-create-all ()
      (interactive)
      (org-map-entries 'org-id-get-create))
    (defun jek-org/prettify-checkboxes ()
      (push '("[ ]" . "🔲") prettify-symbols-alist)
      (push '("[X]" . "☑" ) prettify-symbols-alist)
      (push '("[-]" . "⭕" ) prettify-symbols-alist)
      (prettify-symbols-mode))

    (defface org-checkbox-done-text
      '((t (:foreground "#71696A" :strike-through t)))
      "Face for the text part of a checked org-mode checkbox.")
    (font-lock-add-keywords
     'org-mode
     `(("^[ \t]*\\(?:[-+*]\\|[0-9]+[).]\\)[ \t]+\\(\\(?:\\[@\\(?:start:\\)?[0-9]+\\][ \t]*\\)?\\[\\(?:X\\|\\([0-9]+\\)/\\2\\)\\][^\n]*\n\\)"
        1 'org-checkbox-done-text prepend)))
    :hook
    ((org-mode . jek-org/after-org-mode-load)
     (org-mode . jek-org/prettify-checkboxes)
     (org-archive . my-org-config/after-org-archive)
     (org-capture-prepare-finalize . org-id-get-create))
    ))

(defun jek-org/init-jek-org-custom ()
  (use-package jek-org-custom
    ))

(defun jek-org/init-org-fancy-priorities ()
  (use-package org-fancy-priorities
    :hook
    (org-mode . org-fancy-priorities-mode)
    :custom
    (org-fancy-priorities-list '("‼" "⇪" "⇣" "☕"))
    (org-priority-faces '((?A . (:foreground "red" :weight bold :inherit org-priority-face))
                          (?B . (:foreground "gray50" :inherit org-priority-face))
                          (?C . (:foreground "yellow" :inherit org-priority-face))
                          (?D . (:foreground "green" :inherit org-priority-face))))
    :custom-face
    (org-priority ((t (:family "Source Code Pro" :inherit font-lock-keyword-face ))))
    ))

(defun jek-org/init-org-variable-pitch ()
  (use-package org-variable-pitch
    :after org
    :hook
    (org-mode . jek-org/org-variable-pitch-load)
    :config
    (defun jek-org/org-variable-pitch-load ()
      (org-variable-pitch-minor-mode 1))
    :custom
    (org-variable-pitch-font `(:family "iA Writer Quattro S" ))
    (org-variable-pitch-fixed-font `(:family "Fira Mono"))
    ))

(defun jek-org/post-init-org-agenda ()
  (use-package org-agenda
    :after org
    :config
    (setq org-agenda-block-separator 9472)
    (setq org-agenda-skip-scheduled-if-done t)
    (setq org-agenda-start-on-weekday nil)
    (setq org-deadline-warning-days 7)
    (defun jek-org/setup-buffer-face ()
      (setq buffer-face-mode-face '(:family "iA Writer Mono S"))
      (buffer-face-mode)
      )
    :hook
    (org-agenda-mode . jek-org/setup-buffer-face)
    ))

(defun jek-org/init-org-super-agenda ()
  (use-package org-super-agenda
    :after (org org-agenda)
    :config
    (setq org-super-agenda-header-map nil)
    (org-super-agenda-mode)
    (setq org-agenda-custom-commands
          '(("h" "IOKI DASHBOARD"
             ((agenda "" (
                          (org-agenda-overriding-header "THIS WEEK")
                          (org-agenda-span 'day)
                          (org-agenda-scheduled-leaders '("   " "%2dx"))
                          ))
              (tags "+inbox"
                    ((org-agenda-overriding-header "INBOX: Entries to refile")))
              (todo "VERIFY"
                    ((org-agenda-overriding-header "FINAL VERIFICATION PENDING")))
              )
             )
            ("w" "WEEKLY REVIEW"
             (
              (todo "DONE"
                    (
                     (org-agenda-overriding-header "DONE!")
                     ))
              (todo "CANCELLED"
                    ((org-agenda-overriding-header "CANCELLED")))
              (todo "TODO"
                    ((org-agenda-overriding-header "TODO Items (without time attached)")
                     (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled 'timestamp))))
              (todo "WAIT"
                    ((org-agenda-overriding-header "WAIT: Items on hold (without time attached)")
                     (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled 'timestamp))))
              )
             )
            ("d" "DAILY"
             ((agenda "" ((org-agenda-span 'day)
                          (org-agenda-compact-blocks t)
                          ;; (org-agenda-deadline-leaders)
                          ;; (org-agenda-scheduled-leaders)
                          (org-agenda-prefix-format '(
                            (agenda . "  %?-12t")
                            ))
                          (org-super-agenda-groups
                           '(
                             (:name "⏰ Calendar" :time-grid t)
                             (:name "Optional" :priority "C" :order 90)
                             (:name "⚠ Overdue!" :deadline past)
                             (:name "⚠ Overdue!" :scheduled past)
                     ;; Discard full-day events from agenda
                     (:discard (:category "Cal"))
                     (:name "⭐ Next" :todo "NEXT")
                     (:name "⭐ Important" :priority "A")
                     (:name "📌 Routines" :category "Routines")
                     (:auto-category t)
                     ))
                  ))
              (alltodo "" ((org-agenda-overriding-header "")
                           (org-agenda-prefix-format '(
                                                       (todo . "  ")
                                                       ))
                           (org-super-agenda-groups
                            '(
                              (:name "Inbox" :tag "inbox")
                              (:name "Verify" :todo "VERIFY")
                              (:discard (:anything t))
                              )
                            )))))))
    ))

(defun jek-org/post-init-org-babel ()
  (use-package org-babel
    :after org
    :config
    (setq org-confirm-babel-evaluate nil)
    (org-babel-do-load-languages 'org-babel-load-languages
                                 '((sql . t)
                                   (shell . t)
                                   (dot . t)
                                   (emacs-lisp . t)
                                   (js . t)
                                   (plantuml . t)))
    ))

(defun jek-org/init-org-starter ()
  (use-package org-starter
    :hook
    (after-init . org-starter-load-all-files-in-path)
    :custom
    (org-starter-load-config-files t)
    :config
    (setq org-starter-path '("~/org/"))
    ))

(defun jek-org/init-org-starter-swiper ()
  (use-package org-starter-swiper
    :after org-starter
    ))

(defun jek-org/init-org-ql ()
  (use-package org-ql
    :after org-agenda
    ))

(defun jek-org/init-ivy-omni-org ()
  (use-package ivy-omni-org
    :after org-ql
    :init
    (spacemacs/set-leader-keys
      "o RET" 'ivy-omni-org)
    :custom
    (ivy-omni-org-file-sources '(org-starter-known-files))
    (ivy-omni-org-content-types '(agenda-commands
                                  org-ql-views
                                  buffers
                                  files
                                  bookmarks))
    ))

(defun jek-org/init-ivy-todo ()
  (use-package ivy-todo
    :after (org ivy)
    :init (spacemacs/set-leader-keys
            "oo" 'ivy-todo)
    :bind ("C-c t" . ivy-todo)
    :commands ivy-todo
    :config
    (setq ivy-todo-default-tags '("project"))))

(defun jek-org/init-ox-tufte ()
  (use-package ox-tufte
    :after org
    :config
    (setq org-html-htmlize-output-type 'css)
    ))

(defun jek-org/init-org-rich-yank ()
  (use-package org-rich-yank :after org))
