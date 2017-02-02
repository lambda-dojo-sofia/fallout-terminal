(in-package #:cl-user)
(defpackage #:fallout.test
  (:use #:cl #:prove #:fallout))
(in-package #:fallout.test)

(defparameter *test-dict* nil)

(plan 1)

(subtest "fallout"

  (subtest "read-file"
    (is (length (fallout::read-file "test-dict.txt")) 4))

  (subtest "sort-by-length"
    (is (fallout::filter-by-length 4 (fallout::read-file "test-dict.txt")) '("port")
        :test 'equal))

  (subtest "get-n-random"
    (let* ((full-dict (fallout::read-file "test-dict.txt"))
           (dict (fallout::filter-by-length 3 full-dict)))
      
      (is (sort (fallout::get-n-random 3 dict) #'string>)
          (sort dict #'string>)))))

(finalize)
