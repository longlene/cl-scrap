(defun string-split (string &optional (c #\Space))
  "Return a list of substrings of string"
  (loop for i = 0 then (1+ j)
        as j = (position c string :start i)
        collect (subseq string i j)
        while j))

(defun string-suffix (string suffix)
  (let* ((suffix-len (length suffix))
         (string-len (length string))
         (base-len (- string-len suffix-len)))
    (if (>= string-len suffix-len)
      (string= string suffix :start1 base-len :end1 nil))))

(defun string-prefix (string prefix)
  (let* ((prefix-len (length prefix))
         (string-len (length string)))
    (if (>= string-len prefix-len)
      (string= string prefix :end1 prefix-len))))

;(with-open-file (in "lisp.c")
;  (when in
;    (loop for line = (read-line in nil)
;          while line do (mapcar (lambda (x) (if (string-suffix-p x "g") (format t "~a~%" x))) (string-split line)))))
