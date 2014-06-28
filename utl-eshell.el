;;; utl-eshell.el --- Additional functionality for eshell

;; Author: Alex Kost <alezost@gmail.com>
;; Created: 4 Sep 2013

;;; Code:

(defun utl-eshell-kill-whole-line (arg)
  "Similar to `kill-whole-line', but respect eshell prompt."
  (interactive "p")
  (if (< (point) eshell-last-output-end)
      (kill-whole-line arg)
    (kill-region eshell-last-output-end
                 (progn (forward-line arg) (point)))))

;;;###autoload
(defun utl-eshell-cd (arg)
  "Start eshell and change directory there to the current one.
ARG has the same meaning as in `eshell'"
  (interactive "P")
  (let ((dir default-directory))
    (eshell arg)
    (eshell/cd dir)))


;;; Eshell prompt
;; idea from <http://www.emacswiki.org/emacs/EshellPrompt>

;; TODO improve regexp
(defvar utl-eshell-prompt-regexp "^[#$] "
  "Regexp for `eshell-prompt-regexp'.")

(defmacro utl-with-face (str &rest properties)
  `(propertize ,str 'face (list ,@properties)))

(defun utl-eshell-prompt ()
  "Function for `eshell-prompt-function'."
  (format "%s %s%s%s %s\n%s "
          (utl-with-face (format-time-string "%H:%M" (current-time))
                        'font-lock-comment-face)
          (eshell/whoami)
          (utl-with-face "@"
                        'escape-glyph)
          system-name
          (utl-with-face (abbreviate-file-name (eshell/pwd))
                        'dired-directory)
          (utl-with-face (if (= (user-uid) 0) "#" "$")
                        'comint-highlight-prompt)))

(defun utl-eshell-previous-matching-input-from-input (arg)
  "Search backwards through input history for match for current input.
Similar to `eshell-previous-matching-input-from-input' but better."
  (interactive "p")
  (if (not (memq last-command '(utl-eshell-previous-matching-input-from-input
				utl-eshell-next-matching-input-from-input)))
      ;; Starting a new search
      (setq eshell-matching-input-from-input-string
	    (buffer-substring (save-excursion (eshell-bol) (point))
			      (point))
	    eshell-history-index nil))
  (eshell-previous-matching-input
   (regexp-quote eshell-matching-input-from-input-string)
   arg))

(defun utl-eshell-next-matching-input-from-input (arg)
  "Search forwards through input history for match for current input."
  (interactive "p")
  (utl-eshell-previous-matching-input-from-input (- arg)))

(provide 'utl-eshell)

;;; utl-eshell.el ends here
