(defvar jek/org-todo-keyword-defaults
  '((:themed-font-family . fixed-pitch-alt)
    (:weight . bold)
    (:themed-foreground .  fg-alt)))

(defun jek/define-org-todo-keyword (keyword &optional properties)
  (let* ((properties (or properties '()))
         (defaulted (map-merge 'list jek/org-todo-keyword-defaults properties))
         (expanded (jek/themed-face-properties defaulted))
         (face-spec (apply '-concat (-map (lambda (x) (list (car x) (cdr x))) expanded))))
    (add-to-list 'org-todo-keyword-faces (-concat (list keyword) face-spec))
    ))

(defun jek/buffer-is-org-starter-managed-p (org-dir)
  (and (buffer-file-name)
       (f-parent-of? org-dir (buffer-file-name)) 
       (jek/filename-is-org-starter-managed-p (buffer-file-name))))

(defun jek/filename-is-org-starter-managed-p (filename)
  (and filename (-contains? org-starter-known-files filename)))

(provide 'jek-org-custom)
