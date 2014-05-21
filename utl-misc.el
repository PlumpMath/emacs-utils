;;; utl-misc.el --- Miscellaneous additional functionality

;; Author: Alex Kost <alezost@gmail.com>
;; Created: 7 Jul 2013

;;; Code:

(defun utl-xor (a b)
  "Exclusive or."
  (if a (not b) b))

;;;###autoload
(defun utl-next-link (&optional search-backward)
  "Go to the next link."
  ;; The function is almost the same as `org-next-link'.
  (interactive)
  (when (and org-link-search-failed
             (eq this-command last-command))
    (goto-char (point-min))
    (message "Link search wrapped back to beginning of buffer"))
  (setq org-link-search-failed nil)
  (let* ((pos (point))
	 (srch-fun (if search-backward
                       're-search-backward
                     're-search-forward)))
    (when (looking-at org-any-link-re)
      ;; Don't stay stuck at link without an org-link face
      (forward-char (if search-backward -1 1)))
    (if (funcall srch-fun org-any-link-re nil t)
	(progn
	  (goto-char (match-beginning 0))
	  (if (outline-invisible-p) (org-show-context)))
      (goto-char pos)
      (setq org-link-search-failed t)
      (message "No further link found"))))

;;;###autoload
(defun utl-previous-link ()
  "Go to the previous link."
  (interactive)
  (utl-next-link t))

;;;###autoload
(defun utl-apply (fun &rest args)
  "Same as `apply', but check if a function is bound."
  (if (fboundp fun)
      (apply fun args)
    (message "Function `%s' is unbound." fun)))

(defun utl-read-string (prompt &optional initial-input history
                              default-value inherit-input-method)
  "Similar to `read-string', but put DEFAULT-VALUE in the prompt."
  (let (prompt-beg prompt-end)
    (if (string-match "^\\(.*\\)\\(:\\s-*\\)$" prompt)
        (setq prompt-beg (match-string 1 prompt)
              prompt-end (match-string 2 prompt))
      (setq prompt-beg prompt
            prompt-end ": "))
    (read-string
     (if default-value
         (format "%s (%s)%s" prompt-beg default-value prompt-end)
       (concat prompt-beg prompt-end))
     initial-input history
     default-value inherit-input-method)))

;;;###autoload
(defun utl-create-tags (shell-cmd)
  "Create tags file using shell command SHELL-CMD.
Interactively prompt for shell command.
With prefix, prompt for directory as well."
  (interactive
   (let ((dir (if current-prefix-arg
                  (read-directory-name "Root tags directory: ")
                "")))
     (list (read-shell-command
            "Shell command for generating tags: "
            (format "find %s -type f -name '*.[ch]' | etags -" dir)))))
  (eshell-command shell-cmd))

;; idea from <http://www.emacswiki.org/emacs-en/DisabledCommands>
;;;###autoload
(defun utl-show-disabled-commands ()
  "Show all disabled commands."
  (interactive)
  (with-output-to-temp-buffer "*Disabled commands*"
    (mapatoms (lambda (symbol)
                (when (get symbol 'disabled)
                  (prin1 symbol)
                  (princ "\n"))))))


;;; Spelling and languages

;;;###autoload
(defun utl-set-isearch-input-method (input-method)
  "Activate input method INPUT-METHOD in interactive search.
See `set-input-method' for details."
  (set-input-method input-method)
  (setq isearch-input-method-function input-method-function)
  (isearch-update))

(provide 'utl-misc)

;;; utl-misc.el ends here
