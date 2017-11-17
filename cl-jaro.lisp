;;;;original is here https://gist.github.com/ronnieoverby/2aa19724199df4ec8af6


(defun jaro-distance (str1 str2)
  (if (string= str1 str2)
      1)
  (let* ((lenstr1 (length str1))
	 (lenstr2 (length str2))
	 (search-range (floor(max 0 (1- (/ (max lenstr1 lenstr2) 2)))))
	 (matched1 (make-array lenstr1 :element-type 'boolean :initial-element nil))
	 (matched2 (make-array lenstr2 :element-type 'boolean :initial-element nil))
	 (common 0)
	 (k 0)
	 (transposed 0))
    (loop
       :for i :from 0 :to (1- lenstr1)
       :for start := (max 0 (- i search-range))
       :for end := (min (+ i search-range 1) lenstr2)
       :do (loop
	      :for j :from start :to (1- end)
	      :for str1i := (aref str1 i)
	      :for str2i := (aref str2 j)
	      :when (and (not (aref matched2 j)) (equal str1i str2i))
	      :do (progn   (setf (aref matched1 i) t)
			   (setf (aref matched2 j) t)
			   (incf common)
			   (loop-finish))))
    (cond ((zerop common)
	   0)
	  (t 
	   (loop
	      :for i :from 0 :upto (1- lenstr1)
	      :for val := (aref matched1 i)
	      :if (or (>= k (1- lenstr2)) (>= i (1- lenstr1)));needed to add a break out if
	      :do (loop-finish);k or i go above the array index max.
	      :unless (not val);if no matches in str1 then continue
	      :do (loop
		     :while (and (not (aref matched2  k)) (< k (1- lenstr2)));while there is no match
		     :do (incf k));in matched2 incf k
	      :unless (not val)
	      :if (not  (equal  (aref str1 i)(aref str2 k)))
	      :do (incf transposed)
	      :do (incf k));incf transpositions   	
	   (/ (+ (/ common lenstr1)
		 (/ common lenstr2);returning the jaro distance
		 (/ (- common (/ transposed 2))
		    common))
	      3.0)))))
#|CL-USER> (jaro-distance "jellyfish" "smellyfish")

0.89629626
CL-USER> (jaro-distance "dixon" "dicksonx")
0.76666665
CL-USER> (jaro-distance "martha" "marhta")
0.9444444
These are the same results that can be found at https://rosettacode.org/wiki/Jaro_distance#C.2B.2B

#|
