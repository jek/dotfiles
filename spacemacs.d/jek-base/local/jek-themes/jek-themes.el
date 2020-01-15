(defvar jek/themes--font-families
  (list (cons 'variable-pitch  "iA Writer Quattro S")
        (cons 'fixed-pitch     (car dotspacemacs-default-font))
        (cons 'fixed-pitch-alt "iA Writer Mono S")
        )
  "Named font families"
  )

(defvar jek/themes--font-face-transforms
  '((:themed-font-family . jek/themes--themed-font-family)
    (:themed-foreground . jek/themes--themed-foreground)
    (:themed-background . jek/themes--themed-foreground)))

(defun jek/themed-font-family (font-role)
  "Resolve 'font-role' (a symbol) to a font family"
  (or
   (alist-get font-role jek/themes--font-families)
   (car dotspacemacs-default-font)
  ))

(defun jek/themed-color (doom-name default)
  "Resolve 'doom-name' (a symbol) in active doom-theme or fallback to default"
  (if (boundp 'doom-themes--colors)
       (car (alist-get doom-name doom-themes--colors (list default)))
     default))

(defun jek/themed-face-properties (properties &optional transforms)
  "Return a face-spec with theme-aware transforms applied"
  (let ((transforms (or transforms jek/themes--font-face-transforms)))
    (progn
      (map-apply
       (lambda (sugar transform)
         (setq properties (jek/themes--apply-sugar properties sugar transform)))
       transforms)
      properties)))

; TODO expansion shouldn't stomp on pre-existing props
(defun jek/themes--apply-sugar (properties sugar fn)
  (if (map-contains-key properties sugar)
      (map-remove (lambda (k v) (equal k sugar))
                  (map-merge 'list properties (funcall fn (map-elt properties sugar))))
    properties))

(defun jek/themes--themed-font-family (family)
  (list (cons :font-family (jek/themed-font-family family))))

(defun jek/themes--face-property-from-themed (face-property arg)
  (let ((doom-name (car arg))
        (default (car (cdr arg))))
    (list (cons face-property (jek/themed-color doom-name default)))))

(defalias 'jek/themes--themed-background
  (apply-partially 'jek/themes--face-property-from-themed :background))

(defalias 'jek/themes--themed-foreground
  (apply-partially 'jek/themes--face-property-from-themed :foreground))

(provide 'jek-themes)
