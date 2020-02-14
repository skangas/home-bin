;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((sh-mode
  (eval add-hook 'before-save-hook #'copyright-update nil t))
 (cperl-mode
  (eval add-hook 'before-save-hook #'copyright-update nil t))
 (python-mode
  (eval add-hook 'before-save-hook #'copyright-update nil t)))
