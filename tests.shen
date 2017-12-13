(load "xuji.shen")

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

(trap-error
  (do

    (assert-equal
      (parse-sql-from-string "
        select x, y
        from t
        join u on a = b")
      [select
       [selections [x y]]
       [sources [t (@p u [= a b])]]])

    (assert-equal
      (parse-sql-from-string "
        create table people
        {
          name varchar,
          phone varchar,
          age int
        }")
      [create
       [name people]
       [columns
        [(@p name varchar)
         (@p phone varchar)
         (@p age int)]]])

    (assert-equal
      (parse-sql-from-string "
        update
          people
        set
          contacted = t,
          email = null
        where
          friend-count > 0
        ")
      [update
       [target people]
       [assignments
        [(@p contacted t)
         (@p email null)]]
       [conditional
        [> friend-count 0]]])

    (assert-equal
      (parse-sql-from-string "
        insert into people
        { name , phone , age }
        values
        { bob , 5551234567 , 30 }")
      [insert
       [target people]
       [columns [name phone age]]
       [values [bob 5551234567 30]]])

    (assert-equal
      (parse-sql-from-string "
        delete from people where age > 30")
      [delete
       [target people]
       [conditional [> age 30]]])

    (output "~%~%~A assertions passed.~%~%" (value *assertion-count*))
    success)

  (/. E (output "~%~%Uncaught error: ~S~%~%" (error-to-string E))))
