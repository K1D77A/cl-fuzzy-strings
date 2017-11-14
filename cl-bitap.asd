;;;;John 1:16 Out of his fullness we have all received grace in place of grace already given

;;;cl-bitap.asd
(asdf:defsystem #:cl-bitap
  :name "cl-bitap"
  :author "Klambda / #lisp Josh_2"
  :license "BSD"
  :description "fuzzy and exact bitap algorithms"
  :components ((:file "packages")
	       (:file "cl-bitap" :depends-on ("packages"))))
