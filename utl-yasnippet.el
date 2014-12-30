;;; utl-yasnippet.el --- Additional functionality for yasnippet

;; Author: Alex Kost <alezost@gmail.com>
;; Created: 7 Jun 2014

;;; Code:

(require 'yasnippet)

;;;###autoload
(defun utl-yas-next-field-or-expand ()
  "Go to the next field if a snippet is in progress or perform an expand."
  (interactive)
  (if (yas--snippets-at-point 'all)
      (goto-char (overlay-start yas--active-field-overlay))
    (yas-expand)))

;;;###autoload
(defun utl-yas-exit-and-expand ()
  "Exit all snippets and expand a snippet before point."
  (interactive)
  (save-excursion (yas-exit-all-snippets))
  (yas-expand))

(provide 'utl-yasnippet)

;;; utl-yasnippet.el ends here
