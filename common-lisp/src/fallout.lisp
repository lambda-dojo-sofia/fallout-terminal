(in-package #:cl-user)
(defpackage #:fallout
  (:use #:cl))
(in-package #:fallout)

(defun read-file (filename)
  (with-open-file (dict-stream (format nil "~A~A"
                                       "/Users/petko/common-lisp/fallout/t/"
                                       filename)
                               :direction :input     
                               :if-does-not-exist :create)
    (loop for line = (read-line dict-stream nil)
       while line
       collect line)))

(defun filter-by-length (word-length dict)
  (remove-if-not #'(lambda (word) (= (length word) word-length)) dict))

;; (defun sample (list)
;;   (nth (random (length list)) list))

(defun k-random (k n i res)
  (let* ((el (random n))
         (present (member el res)))
    (if (eq i k)
        res
        (if present
            (k-random k n i res)
            (k-random k n (1+ i) (push el res))))))

(defun get-n-random (word-count dict)
  (let ((positions (k-random word-count (length dict) 0 nil)))
    (mapcar #'(lambda (position) (nth position dict)) positions)))

(defun hdist (str1 str2)
  (count t
         (loop
            for str1-char across str1
            for str2-char across str2
            collect (char= str1-char str2-char))))

(defun main (word-count word-length dict guess)
  (let* ((guesses (get-n-random word-count (filter-by-length word-length dict)))
         (password (nth (random word-count) guesses)))
    (print guesses)
    (mapcar #'hdist password guess)))
