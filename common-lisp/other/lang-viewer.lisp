#!/usr/bin/sbcl --script

;; equal to java: readShort
(defun read-u2 (in)
  (+ (* (read-byte in) (expt 2 8))
     (* (read-byte in) 1)))

;; equal to java: readInt
(defun read-u4 (int)
  (+ (* (read-byte in) (expt 2 24))
     (* (read-byte in) (expt 2 16))
     (* (read-byte in) (expt 2 8))
     (* (read-byte in) (expt 2 0))))


