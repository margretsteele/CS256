(defun factorial(x)
  (if (= x 1) 1
    (* x (factorial (- x 1)))
  )
)

(defun sumDigits(x)
  (if (= x 0) 0
    (+ (mod x 10) (sumDigits (/ (- x (mod x 10)) 10)))
  )
)














