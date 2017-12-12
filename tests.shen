(set *assertion-count* 0)

(define assertion-pass ->
  (set *assertion-count* (+ 1 (value *assertion-count*))))

(define terminate Message ->
  (do
    (output Message)
    (exit 1)))

(define assert
  false Message -> (terminate Message)
  _ _ -> (assertion-pass))

(define assert-equal
  X X -> (assertion-pass)
  X Y -> (terminate (make-string "~%~%~A~%~%is not equal to~%~%~A~%~%" X Y)))

(define expect-error
  F Message ->
    (trap-error
      (do (F) (terminate Message))
      (/. _ (assertion-pass))))

(defmacro assert-macro
  [assert X] -> [assert X "Assert failed"]
  [expect-error X] -> [expect-error X "Error expected"])

(define xuji-tests ->
  (do
    (assert-equal
      (parse-sql-from-string "
        select x, y
        from t
        join u on a = b")
      [select
       [selections [x y]]
       [sources [t (@p u [= a b])]]])
    (output "~%~%~A assertions passed.~%~%" (value *assertion-count*))
    success))
