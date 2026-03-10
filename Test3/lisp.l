(defun chooseFunction ( )
(if (y-o-n-p "Do you want max?") #'max   #'min))
      (funcall (chooseFunction) 10 2 35 6)
