;;; utl-w3m.el --- Additional functionality for w3m

;; Author: Alex Kost <alezost@gmail.com>
;; Created: 24 Sep 2013

;;; Code:

(require 'cl-lib)
(require 'w3m)
(require 'wget nil t)


;;; Go to the next/previous link

(defvar utl-w3m-search-link-depth 10
  "The number of links to search for the next/previous URL.
See `utl-w3m-next-url'/`utl-w3m-previous-url' for details.")

(defvar utl-w3m-search-re "\\<%s\\>"
  "Regexp for searching next/previous URL.
The string should contain \"%s\"-expression substituted by a
searched word. ")

(defun utl-w3m-search-url (word point fun)
  "Search an URL anchor beginning with WORD.

POINT is the start point for searching.

FUN is a function used for going to an anchor (like
`w3m-next-anchor' or `w3m-previous-anchor').  FUN is called
`utl-w3m-search-link-depth' times.

Return URL of the found anchor or nil if the link is not found."
  (save-excursion
    (goto-char point)
    (cl-loop for i from 1 to utl-w3m-search-link-depth
             do (funcall fun)
             if (looking-at (format utl-w3m-search-re word))
             return (w3m-anchor))))

(defmacro utl-w3m-define-goto-url (type)
  "Define a function for going to the next/previous page.
TYPE should be a string \"next\" or \"previous\".
Defined function has a name `utl-w3m-TYPE-url'."
  (let ((name (intern (concat "utl-w3m-" type "-url")))
        (desc (concat "Go to the " type " page.\n"
                      "If `w3m-" type "-url' is nil, search in the first and last\n"
                      "`utl-w3m-search-link-depth' links for the " type " page URL."))
        (type-url    (intern (concat "w3m-" type "-url"))))
    `(defun ,name ()
       ,desc
       (interactive)
       (let ((url (or ,type-url
                      (utl-w3m-search-url ,type (point-min) 'w3m-next-anchor)
                      (utl-w3m-search-url ,type (point-max) 'w3m-previous-anchor))))
         (if url
             (let ((w3m-prefer-cache t))
               (w3m-history-store-position)
               (w3m-goto-url url))
           (message ,(concat "No '" type "' link found.")))))))

(utl-w3m-define-goto-url "next")
(utl-w3m-define-goto-url "previous")

;;;###autoload (autoload 'utl-w3m-next-url "utl-w3m" nil t)
;;;###autoload (autoload 'utl-w3m-previous-url "utl-w3m" nil t)



;;;###autoload
(defun utl-w3m-wget ()
  "Download anchor, image, or current page.
Same as `w3m-wget' but works."
  (interactive)
  (let ((url (or (w3m-anchor) (w3m-image)))
        (wget-current-title w3m-current-title))
    (wget-api url w3m-current-url)))

(defun utl-w3m-buffer-number-action (function buffer-number)
  "Call FUNCTION on a w3m buffer with BUFFER-NUMBER.
Buffers are enumerated from 1."
  (let ((buf (nth (- arg 1) (w3m-list-buffers))))
    (and buf (funcall function buf))))

;;;###autoload
(defun utl-w3m-switch-to-buffer (arg)
  "Switch to a w3m buffer number ARG.
Buffers are enumerated from 1."
  (interactive "NSwitch to w3m buffer number: ")
  (utl-w3m-buffer-number-action #'switch-to-buffer arg))

;;;###autoload
(defun utl-w3m-kill-buffer (arg)
  "Kill a w3m buffer number ARG.
Buffers are enumerated from 1."
  (interactive "NKill w3m buffer number: ")
  (utl-w3m-buffer-number-action #'kill-buffer arg))

(provide 'utl-w3m)

;;; utl-w3m.el ends here
