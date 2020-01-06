;; based on https://github.com/fabrik42/.spacemacs.d/blob/master/config/my-org-config.el

;(setq org-directory "~/Documents/Org/")

(setq org-log-state-notes-into-drawer t)

(defun my-org-config/setup-buffer-face ()
  (setq buffer-face-mode-face '(:family "iA Writer Mono S"))
  (buffer-face-mode)
  )
(add-hook 'org-agenda-mode-hook 'my-org-config/setup-buffer-face)

(defun my-org-config/after-org-mode-load ()
  (visual-line-mode)
  (vi-tilde-fringe-mode -1)

  (require 'org-indent)
  (org-indent-mode)
  (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))

  (variable-pitch-mode 1)

  ;; (turn-on-olivetti-mode)
  ;; (with-eval-after-load 'olivetti
  ;;   (olivetti-set-width 81)
  ;;   (olivetti-mode 1))
  )

(add-hook 'org-mode-hook 'my-org-config/after-org-mode-load)

(defun my-org-config/after-org-archive ()
  (org-save-all-org-buffers))

(add-hook 'org-archive-hook 'my-org-config/after-org-archive)

(require 'org-checklist)

(spacemacs/declare-prefix "o" "org mode")

(defun my-org-daily-agenda ()
  (interactive)
  (org-agenda nil "d")
  )

(spacemacs/set-leader-keys "od" 'my-org-daily-agenda)

(defun my-org-add-todo ()
  (interactive)
  (org-capture nil "t")
  )
(spacemacs/set-leader-keys "ot" 'my-org-add-todo)

(spacemacs/set-leader-keys "oc" 'org-capture)

(spacemacs/set-leader-keys "oa" 'org-agenda)

(spacemacs/set-leader-keys "ol" 'org-store-link)

(defun my-org-helm-find-file ()
  (interactive)
  (helm-browse-project-find-files "~/Documents/Org/")
  )

(spacemacs/set-leader-keys "of" 'my-org-helm-find-file)

(defvar org-my-inbox-file "~/Documents/Org/inbox.org")
(defvar org-my-mobile-inbox-file "~/Documents/Org/inbox_mobile.org")
(setq org-default-notes-file org-my-inbox-file)
(defvar org-my-general-files "~/Documents/Org/")
;; /Note:/ Right now, I would like to have =TODOs= in my project files as well. However, this does not play well with [[https://beorgapp.com/][beorg]], as the app only allows one org directory without subfolders. :(
(defvar org-my-projects-dir "~/Documents/Org/projects/")

(with-eval-after-load 'org-agenda
  (require 'org-projectile)
  (setq org-agenda-files (append org-agenda-files (org-projectile-todo-files))))

(add-to-list 'org-agenda-files org-my-general-files)
(add-to-list 'org-agenda-files org-my-projects-dir)

(setq org-refile-targets (quote (
                                 (org-agenda-files :maxlevel . 2)
                                 )))

(setq org-reverse-note-order t)

(setq org-capture-templates '(("t" "Todo [inbox]"
                                entry
                                (file "~/Documents/Org/inbox.org")
                                "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n  %i\n")
                              ("d" "Todo w/date [inbox]"
                                entry
                                (file "~/Documents/Org/inbox.org")
                                "* TODO %? %<%Y-%m-%d>\n:PROPERTIES:\n:CREATED: %U\n:END:\n  %i\n")
                              ("l" "Link currently stored [inbox]"
                                entry
                                (file "~/Documents/Org/inbox.org")
                                "* TODO %i%?\n:PROPERTIES:\n:CREATED: %U\n:END:\n\%A\n%i\n")
                              ("m" "Meeting [inbox]"
                                entry
                                (file "~/Documents/Org/inbox.org")
                                "* Meeting %<%Y-%m-%d>: %^{prompt}\n:PROPERTIES:\n:CREATED: %U\n:END:\n- [ ] %?\n\n")))

(org-super-agenda-mode)
(setq org-super-agenda-header-map nil)
(setq org-deadline-warning-days 7)
(setq org-agenda-block-separator 9472)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-start-on-weekday nil)

(setq org-agenda-custom-commands '(
    ("h" "IOKI DASHBOARD"
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
                    ))))
     )
    ))

(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)

(setq header-line-format " ")
(setq org-ellipsis "  ")
(setq org-hide-emphasis-markers t)
(setq org-fontify-whole-heading-line t)
(setq org-fontify-done-headline t)
(setq org-fontify-quote-and-verse-blocks t)
(setq org-bullets-bullet-list '("⬢" "◆" "▲" "■"))
(setq org-tags-column 0)

(let* (
       (comment      "#6272a4")
       (warning      "#ffb86c")
       (rainbow-1    "#f8f8f2")
       (rainbow-2    "#8be9fd")
       (rainbow-3    "#bd93f9")
       (rainbow-4    "#ff79c6")
       (rainbow-5    "#ffb86c")
       (rainbow-6    "#50fa7b")
       (rainbow-7    "#f1fa8c")
       (rainbow-8    "#0189cc")
       (rainbow-9    "#ff5555")
       (rainbow-10   "#a0522d")

       (variable-pitch-font `(:family "iA Writer Quattro S" ))
       (fixed-pitch-font    `(:family "Fira Mono" ))
       (fixed-pitch-font-alt `(:family "iA Writer Mono S" )))

  (setq org-todo-keyword-faces (list
                              `("TODO"
                                ,@fixed-pitch-font
                                :foreground ,comment
                                :weight bold
                                )
                              `("NEXT"
                                ,@fixed-pitch-font
                                :foreground ,warning
                                :weight bold)
                              `("WAIT"
                                ,@fixed-pitch-font
                                :foreground ,rainbow-2
                                :weight bold)
                              `("VERIFY"
                                ,@fixed-pitch-font
                                :foreground ,rainbow-7
                                :weight bold)
                              `("LOWPRIO"
                                ,@fixed-pitch-font
                                :foreground ,comment
                                :weight bold)
                              `("DONE"
                                ,@fixed-pitch-font
                                :foreground ,rainbow-6
                                :weight bold)
                              `("CANCELLED"
                                ,@fixed-pitch-font
                                :foreground ,rainbow-9
                                :weight bold)
                              ))
  )


(setq org-src-fontify-natively t)

(setq org-edit-src-content-indentation 0)
(setq org-src-tab-acts-natively t)
(setq org-src-preserve-indentation t)

(setq org-confirm-babel-evaluate nil)

(org-babel-do-load-languages 'org-babel-load-languages
                             '((sql . t)
                               (shell . t)
                               (dot . t)
                               (emacs-lisp . t)
                               (js . t)
                               (plantuml . t)))
(require 'ox-tufte)

(setq org-plantuml-jar-path "/usr/local/Cellar/plantuml/1.2019.13/libexec/plantuml.jar")

(setq org-html-htmlize-output-type 'css)

(setq org-download-method 'attach)

(require 'org-crypt)
(setq org-tags-exclude-from-inheritance (quote ("crypt")))
(setq org-crypt-key "DEAE8B55")
(org-crypt-use-before-save-magic)
(setq org-crypt-disable-auto-save t)
(setq org-tag-alist '(("crypt" . ?c)))

(spacemacs/set-leader-keys-for-major-mode
  'org-mode "se" 'org-encrypt-entry)

(spacemacs/set-leader-keys-for-major-mode
  'org-mode "sd" 'org-decrypt-entry)

(spacemacs/set-leader-keys-for-major-mode
  'org-mode "k" 'org-todo)

(spacemacs/set-leader-keys-for-major-mode
  'org-mode "ir" 'org-rich-yank)


(use-package ivy-todo :ensure t
  :bind ("C-c t" . ivy-todo)
  :commands ivy-todo
  :config
  (setq ivy-todo-default-tags '("PROJECT")))

(provide 'jek-org)
