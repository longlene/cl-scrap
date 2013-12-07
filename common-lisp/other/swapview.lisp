#!/usr/bin/sbcl --script
(defparameter *first* t)
(defparameter *file-list* (directory "/proc/*/"))
(defparameter *total* 0)

(defun number-string-p (str)
  (= (length str) (second (multiple-value-list (parse-integer str :junk-allowed t)))))

(defun get-swap-size-in-line (line)
  (if (search "Swap" line)
    (parse-integer (subseq line (1+ (position #\: line))) :junk-allowed t)
    0))

(defun path-check (path)
  "Return t if the pathname is a process path like /proc/1"
  (number-string-p (subseq path 6 (position #\/ path :from-end t))))

(defun get-original-swap-size (path)
  "Calculate the swap in smaps in path"
  (with-open-file (stream path :if-does-not-exist nil)
    (if stream
      (loop for line = (read-line stream nil nil)
            while line 
            summing (get-swap-size-in-line line))
      0)))

(defun get-swap-size (path)
  (ignore-errors
    (let ((size (get-original-swap-size path)))
      (cond
        ((> size 1024) (format nil "~1$MiB" (float (/ size 1024))))
        ((> size 0) (format nil "~1$KiB" size))
        (t "0")))))


(defun get-process-id (path)
  "Return process id from the path"
  (subseq path 6 (position #\/ path :from-end t)))

(defun get-cmdline (path)
  "Return process cmdline"
  (with-open-file (stream path :if-does-not-exist nil)
    (if stream
      (substitute #\Space #\Nul (read-line stream nil nil))
      "")))


(defun process (path)
  "The main process function which read with pathname, then return multi-value"
  (if (path-check path)
    (let ((id (get-process-id path))
          (size (get-swap-size (concatenate 'string path "smaps")))
          (cmdline (get-cmdline (concatenate 'string path "cmdline")))
          (format-string "~5@A~8T~8@A~8T~A~%"))
      (cond
        ((and *first* (and size (string/= size "0"))) (progn (setf *first* nil)
                                                             (format t format-string "PID" "SWAP" "COMMAND")
                                                             (format t format-string id size cmdline)
                                                             (incf *total* (get-original-swap-size (concatenate 'string path "smaps"))))) 
        ((and size (string/= size "0")) (progn (format t format-string id size cmdline)
                                               (incf *total* (get-original-swap-size (concatenate 'string path "smaps")))))))))
(defun main ()
  (progn
    (loop for x in *file-list*
          do (let ((path (namestring x)))
               (if (and 
                     #+(or sbcl lispworks opencml) (probe-file path)
                     #+clisp (probe-directory path)
                     #-(or sbcl lispworks opencml clisp) (error "What's your lisp? Please tell me!!")
                     (probe-file (concatenate 'string path "smaps"))
                     (probe-file (concatenate 'string path "cmdline")))
                 (process path))))
    (if (not (= *total* 0))
      (let ((sum (if (> *total* 1024)
                   (format nil "~1$MiB" (float (/ *total* 1024)))
                   (format nil "~1$KiB" *total*))))
        (format t "Total: ~A~%" sum)))))
(main)
