;;; utl-window.el --- Additional functionality for working with windows and frames

;; Author: Alex Kost <alezost@gmail.com>
;; Created: 10 Aug 2013

;;; Code:


;;; Make 2 windows

;;;###autoload
(defun utl-make-2-windows (&optional fun)
  "Make 2 windows in the current frame.
FUN is a function for splitting
windows (`split-window-vertically' by default)."
  (interactive)
  (or fun
      (setq fun 'split-window-below))
  (if (one-window-p)
      (funcall fun)
    (let ((cur-buffer (current-buffer)))
      (other-window -1)
      (delete-other-windows)
      (funcall fun)
      (switch-to-buffer cur-buffer))))

;;;###autoload
(defalias 'utl-make-vertical-windows 'utl-make-2-windows
  "Make 2 vertical windows.
If there is only one window, split it.
If there are more windows, show current and previous buffer in new
windows.")

;;;###autoload
(defun utl-make-horizontal-windows ()
  "Make 2 horizontal windows.
If there is only one window, split it.
If there are more windows, show current and previous buffer in new
windows."
  (interactive)
  (utl-make-2-windows 'split-window-right))



;;;###autoload
(defun utl-switch-windows ()
  "Switch current and previous windows (show switched buffers)."
  (interactive)
  (and (null (one-window-p))
    (let ((cur-buffer (current-buffer)))
      (other-window -1)
      (switch-to-buffer cur-buffer)
      (other-window 1)
      (switch-to-buffer nil)
      (other-window -1))))

;;;###autoload
(defun utl-switch-to-minibuffer ()
  "Switch to minibuffer window."
  (interactive)
  (let ((mb (active-minibuffer-window)))
    (if mb
        (select-window mb)
      (error "Minibuffer is not active"))))

;;;###autoload
(defun utl-maximize-frame (&optional current-frame)
  "Maximize active frame using 'wmctrl'.
The variable CURRENT-FRAME affects nothing, it is used for
`after-make-frame-functions' (for maximizing new frames)."
  (interactive)
  (shell-command "wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz"))

(provide 'utl-window)

;;; utl-window.el ends here
