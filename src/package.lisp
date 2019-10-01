;;;;Bitap fuzzy and exact match searches
(in-package :cl-user)
(defpackage #:cl-fuzzy-strings
  (:use #:CL)
  (:export
   :fuzzy-search-string
   :search-string
   :levenshtein-distance
   :jaro-distance
   :exact-string-bitap
   :fuzzy-bitap
   :bitap-exact)
  (:nicknames "cl-fs"))
(in-package #:cl-fuzzy-strings)
