;;;;My attempt at the Bitap algorithm described at https://en.wikipedia.org/wiki/Bitap_algorithm
#| The bitap algorithm (also known as the shift-or, shift-and or Baeza-Yates–Gonnet algorithm)
;; is an approximate string matching algorithm. The algorithm tells whether a given text contains a substring which is "approximately equal" to a given pattern, where approximate equality is defined in terms of Levenshtein distance — if the substring and pattern are within a given distance k of each other, then the algorithm considers them equal.
;; The algorithm begins by precomputing a set of bitmasks containing one bit for each element of the
 pattern. Then it is able to do most of the work with bitwise operations, which are extremely fast.|#
(in-package #:cl-fuzzy-strings)
;;;point of note this is not in a functional style. 
(defun exact-string-bitap(strng pattern)
  "Takes in a string and a pattern, then if it finds the pattern, it will return the array index where it starts in strng"
  (let ((pat-len (length pattern))
	(bitmasks (lognot 1))
	(pattern-mask (make-array 127 :initial-element (lognot 0))))
    (cond ((zerop pat-len)
	   (format t "No matching required~%"))
	  ((> pat-len 31)
	   (error "The pattern is too long"))
	  (t (progn (dotimes (i pat-len)
		      (setf (aref pattern-mask
				  (char-code (aref pattern i)));;char-code converts chars to ascii
			    (logand (lognot (ash 1 i)))));;ash is the equivalent of bitshifting
		    (dotimes (i (length strng));;because you can perform bit shifting on ints in CL
		      (setf bitmasks (ash (logior (aref pattern-mask (char-code (aref strng i)))) 1))
		      (if (= 0 (logand bitmasks (ash 1 pat-len)))
			  (return (1+ (- i pat-len))))))))))
(defun fuzzy-bitap (strng pattern distance-k)
  "Takes in a string, a pattern and an acceptable number of errors. and returns the starting index for an 'acceptable' match"
  (let ((result nil)
	(pat-len (length pattern))
	(bitmasks (make-array  (* (1+ distance-k)(1- 4))))
	(pattern-mask (make-array 128 :initial-element (lognot 0))))
    (cond ((zerop pat-len)
	   (format t "No matching required~%"))
	  ((> pat-len 31)
	   (error "The pattern is too long"))
	  (t (progn
	       (dotimes (i distance-k)
		 (setf (aref bitmasks i) (lognot 1)))
	       (dotimes (i pat-len)
		 (setf (aref pattern-mask
			     (char-code (aref pattern i)))
		       (logand (lognot (ash 1 i)))));;ash is the equivalent of bitshifting
	       (dotimes (i (length strng))
		 (let ((old-r  (aref bitmasks 0)))
		   (setf (aref bitmasks 0)
			 (ash (logior (aref bitmasks 0)
				      (aref pattern-mask (char-code (aref strng i))))
			      1))
		   (print result)
		   (loop :for iter :from 1 :to distance-k
		      :for tmp := (aref bitmasks iter)
		      :do (setf (aref bitmasks iter)
				(ash (logand old-r (logior
						    (aref bitmasks iter)
						    (aref pattern-mask
							  (char-code (aref strng i)))))
				     1))
		      :do (setf old-r tmp))
		   (if (zerop (logand (aref bitmasks distance-k) (ash 1 pat-len)))
		       (setf result (1+ (- i pat-len)))))))))
    result))
    
    
(defun bitap-exact (text pattern)
  (cond ((null pattern)
	 text)
	((> (length pattern) 31)
	 (format t "Pattern too long"))
	(t (let ((m (length pattern))
		 (r (lognot 1))
		 (mask (make-array 128 :initial-element (lognot 0))))
	     (dotimes (i m)
	       (let ((val (aref mask (char-code(aref pattern i)))))
		 (setf (aref mask (char-code(aref pattern i))) (logand val (lognot (ash 1 i))))))
	     (loop :for i :from 0 :while (aref text i)
		:do (setf r (logior (aref mask (char-code(aref text i)))))
		:do (setf r (ash r 1))
		:if (zerop (logand r (ash 1 m)))
		:return (1+ (- i m)))))))
