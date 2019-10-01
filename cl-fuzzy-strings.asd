(in-package #:asdf-user)
(asdf:defsystem "cl-fuzzy-strings"
  :description "Some fuzzy string algorithms"
  :name "cl-fuzzy-strings"
  :author "K1D77A"
  :version "1"
  :license "MIT"
  :pathname "src"
  :serial t
  :components ((:file "package")
	       (:file "cl-bitap")
	       (:file "cl-jaro")
	       (:file "cl-levenshtein")))
