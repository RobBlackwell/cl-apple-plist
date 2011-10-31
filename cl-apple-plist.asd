;;;; cl-plist.asd

(asdf:defsystem #:cl-apple-plist
  :version "0.1"
  :author "Rob Blackwell"
  :description "Encodes Common Lisp data structures in Apple property list XML format (.plist)."
  :serial t
  :depends-on (#:html-encode)
  :components ((:file "package")
	       (:file "plist")))


