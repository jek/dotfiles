(defun jek-org/daily-agenda ()
  (interactive)
  (org-agenda nil "d")
  )

(defun jek-org/add-todo ()
  (interactive)
  (org-capture nil "t")
  )
