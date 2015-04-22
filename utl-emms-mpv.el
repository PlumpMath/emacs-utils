;;; utl-emms-mpv.el --- Additional functionality for using EMMS with mpv

;; Author: Alex Kost <alezost@gmail.com>
;; Created: 17 Apr 2015

;;; Code:

(require 'emms-player-simple-mpv)

(defun utl-emms-mpv-run-command (command)
  "Run mpv COMMAND for the current EMMS mpv process.
COMMAND is what may be put in mpv conf-file, e.g.: 'cycle mute',
'show_text ${playback-time}', etc."
  (interactive "sRun mpv command: ")
  (when (emms-player-simple-mpv-playing-p)
    (tq-enqueue emms-player-simple-mpv--tq
                (concat command "\n")   ; newline is vital
                "" nil #'ignore)))

(defun utl-emms-mpv-show-progress ()
  "Show progress in the OSD of the current video."
  (interactive)
  (utl-emms-mpv-run-command "show_progress"))

(defun utl-emms-mpv-toggle-fullscreen ()
  "Toggle fullscreen."
  (interactive)
  (utl-emms-mpv-run-command "cycle fullscreen"))

(defun utl-emms-mpv-sync-playing-time ()
  "Synchronize `emms-playing-time' with the real time reported by mpv."
  (interactive)
  (emms-player-simple-mpv-tq-enqueue
   '("get_property" "time-pos")
   nil
   (lambda (_ ans-ls)
     (if (emms-player-simple-mpv-tq-success-p ans-ls)
         (let ((sec (round (emms-player-simple-mpv-tq-assq-v
                            'data ans-ls))))
           (message "Old playing time: %d; new time: %d"
                    emms-playing-time sec)
           (setq emms-playing-time sec))
       (message "mpv refuses to report about playing time")))))

(defun utl-emms-mpv-add-simple-player ()
  "Generate `emms-player-mpv' player."
  (define-emms-simple-player-mpv mpv
    '(file url streamlist playlist)
    (concat "\\`\\(http\\|mms\\)://\\|"
            (emms-player-simple-regexp
             "ogg" "mp3" "wav" "mpg" "mpeg" "wmv" "wma"
             "mov" "avi" "divx" "ogm" "ogv" "asf" "mkv"
             "rm" "rmvb" "mp4" "flac" "vob" "m4a" "ape"
             "flv" "webm"))
    "mpv" "--no-terminal")
  (emms-player-simple-mpv-add-to-converters
   'emms-player-mpv "." '(playlist)
   (lambda (track-name)
     (format "--playlist=%s" track-name))))

(provide 'utl-emms-mpv)

;;; utl-emms-mpv.el ends here
