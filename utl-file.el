;;; utl-file.el --- Additional functionality for working with files

;; Author: Alex Kost <alezost@gmail.com>
;; Created: 8 Nov 2012

;;; Code:

;;;###autoload
(defun utl-sudo-find-file (&optional arg)
  "Find current file or dired directory with root privileges.
If ARG is nil use `find-alternate-file', otherwise - `find-file'."
  (interactive "P")
  (let ((file (or (and (eq major-mode 'dired-mode)
                       dired-directory)
                  buffer-file-name
                  (error "Current buffer should visit a file or be in a dired-mode")))
        (window-start (window-start))
        (point (point))
        (mark (and mark-active (region-beginning))))
    (funcall (if arg 'find-file 'find-alternate-file)
             (format "/sudo::%s" file))
    (and mark (set-mark mark))
    (goto-char point)
    (set-window-start nil window-start)))

(defvar utl-ssh-default-user user-login-name
  "A default user name for `utl-ssh-find-file'.
Can be a string or a list of strings (names).")
(defvar utl-ssh-default-host "remote-host"
  "A default host name for `utl-ssh-find-file'.
Can be a string or a list of strings (hosts).")

;;;###autoload
(defun utl-ssh-find-file (&optional user host)
  "Find a file for a USER on a HOST using tramp ssh method.
If USER and HOST are not specified, values from
`utl-ssh-default-user' and `utl-ssh-default-host' will be used.
Interactively with \\[universal-argument] prompt for a user name,
with \\[universal-argument] \\[universal-argument] prompt for a default host as well."
  (interactive
   (list (and (or (equal current-prefix-arg '(4))
                  (equal current-prefix-arg '(16)))
              (ido-completing-read "User: "
                                   (if (listp utl-ssh-default-user)
                                       utl-ssh-default-user
                                     (list utl-ssh-default-user))))
         (and (equal current-prefix-arg '(16))
              (ido-completing-read "Host: "
                                   (if (listp utl-ssh-default-host)
                                       utl-ssh-default-host
                                     (list utl-ssh-default-host))))))
  (or user (setq user (or (and (listp utl-ssh-default-user)
                               (car utl-ssh-default-user))
                          utl-ssh-default-user)))
  (or host (setq host (or (and (listp utl-ssh-default-host)
                               (car utl-ssh-default-host))
                          utl-ssh-default-host)))
  (with-current-buffer
      (find-file-noselect (format "/ssh:%s@%s:/" user host))
    (ido-find-file)))

(provide 'utl-file)

;;; utl-file.el ends here
