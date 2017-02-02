(in-package #:cl-user)
(defpackage #:fallout-asd
  (:use #:cl #:asdf))
(in-package #:fallout-asd)

(defsystem #:fallout
  :version      "0.1.0"
  :description  "Lambda Dojo stuff"
  :author       "Team"
  :serial       t
  :license      "MIT"
  :depends-on   ()
  :components   ((:module "src"
                          :components
                          ((:file "fallout"))))
  :in-order-to ((test-op (test-op fallout-test))))

(defsystem #:fallout-test
  :description "Lambda Dojo stuff test system"
  :author "Petko Tsikov <tsikov@gmail.com>"
  :license "MIT"
  :depends-on (#:prove)
  :defsystem-depends-on (#:prove-asdf)
  :serial t
  :components ((:module "t"
                        :components
                        ((:test-file "fallout"))))
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run) :prove) c)))
