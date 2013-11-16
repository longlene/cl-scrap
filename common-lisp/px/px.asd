(asdf:defsystem #:px
                :description "px is an posix layer for Common Lisp"
                :author "loong0 <longlene@gmail.com>"
                :version "0.1"
                :serial t
                :compoent ((:file "package")
                           (:file "getenv")
                           (:file "getpid")))
