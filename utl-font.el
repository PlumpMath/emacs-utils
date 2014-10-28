;;; utl-font.el --- Additional functionality for working with fonts

;; Author: Alex Kost <alezost@gmail.com>
;; Created: 22 Oct 2014

;;; Code:

(require 'cl-lib)


;;; Choosing the first available font

;; Idea from <http://www.emacswiki.org/emacs/SetFonts>.

(defvar utl-font-candidates
  '("Liberation Mono-12" "DejaVu Sans Mono-11" "Terminus-12")
  "List of font names used by `utl-first-existing-font'.")

(defun utl-first-existing-font (&rest font-names)
  "Return first existing font from FONT-NAMES.
If FONT-NAMES is nil, use `utl-font-candidates'."
  (cl-find-if (lambda (name)
                (find-font (font-spec :name name)))
              (or font-names utl-font-candidates)))


;;; Setting different fonts for different characters

;; See (info "(emacs) Modifying Fontsets"),
;; <http://www.emacswiki.org/emacs/FontSets> and
;; <http://paste.lisp.org/display/133488> for more information.

(defun utl-set-fontset (&optional name frame add &rest specs)
  "Modify fontset NAME.
Each specification from SPECS list has the following form:

  (FONT . TARGETS)

TARGETS is a list of characters TARGET.  See `set-fontset-font'
for details."
  (mapc (lambda (spec)
          (let ((font    (car spec))
                (targets (cdr spec)))
            (mapc (lambda (target)
                    (set-fontset-font name target font frame add))
                  targets)))
        specs))


(provide 'utl-font)

;;; utl-font.el ends here
