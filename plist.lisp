;;;; plist.lisp
;;;; Copyright (c) 2011, Rob Blackwell.

;;; Encodes Common Lisp data structures in Apple property list XML format (.plist).

(in-package #:cl-apple-plist)

(defgeneric encode-apple-plist-node (object &optional stream)
  (:documentation "Encodes the given object as a plist XML node"))

(defmethod encode-apple-plist-node ((self cons) &optional (stream t))
  "Encodes a list as an array node in plist format"
  (format stream "<array>~%")
  (dolist (x self)
    (encode-apple-plist-node x stream))
  (format stream "</array>~%"))

(defmethod encode-apple-plist-node ((self vector) &optional (stream t))
  "Encodes a vector as an array node in plist format"
  (format stream "<array>~%")
  (map nil #'(lambda(x)
	       (encode-apple-plist-node x stream)) self)
  (format stream "</array>~%"))

(defmethod encode-apple-plist-node ((self string) &optional (stream t))
  "Encodes a string in plist format"
  (if (string= self "")
      (format stream "<string/>~%")
      (format stream "<string>~a</string>~%" (html-encode:encode-for-pre self))))

(defmethod encode-apple-plist-node ((self integer) &optional (stream t))
  "Encodes an integer in plist format"
  (format stream "<integer>~a</integer>~%" self))

(defmethod encode-apple-plist-node ((self float) &optional (stream t))
  "Encodes a float in plist format"
  (format stream "<real>~a</real>~%" self))

(defmethod encode-apple-plist-node ((self (eql t)) &optional (stream t))
  "Encodes t as a true node in plist format"  
  (format stream "<true/>~%"))

(defmethod encode-apple-plist-node ((self (eql nil)) &optional (stream t))
  "Encodes nil as a false node in plist format"  
  (format stream "<false/>~%" self))

(defmethod encode-apple-plist-node ((self hash-table) &optional (stream t))
  "Encodes a hastable as a dict node in plist format"  
  (format stream "<dict>~%")
  (maphash #'(lambda ( k v)
	       (format stream "<key>~a</key>" k)
	       (encode-apple-plist-node v stream)) self)
  (format stream "</dict>~%"))

(defun encode-apple-plist (object &optional (stream t))
  "Encodes the given data structure in Apple plist XML format"
  (format stream "<?xml version=\"1.0\" encoding=\"UTF-8\"?>~%")
  (format stream "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">~%")
  (format stream "<plist version=\"1.0\">~%")
  (encode-apple-plist-node object stream)
  (format stream "</plist>~%"))

(defun encode-apple-plist-to-file (object filename)
  "Encodes the given data structure in Apple plist XML format which is written to the given file"
  (with-open-file (stream filename :direction :output :if-exists :supersede)
    (encode-apple-plist object stream)))

