(deftheme werkor
  "")

(custom-theme-set-faces
 'werkor
 '(font-lock-builtin-face ((t (:foreground "#DAB98f"))))
 '(font-lock-comment-face ((t (:foreground "gray50"))))
 '(font-lock-constant-face ((t (:foreground "olive drab"))))
 '(font-lock-doc-face ((t (:inherit gray50))))
 '(font-lock-function-name-face ((t (:foreground "burlywood3"))))
 '(font-lock-keyword-face ((t (:foreground "DarkGoldenrod3"))))
 '(font-lock-string-face ((t (:foreground "olive drab"))))
 '(font-lock-type-face ((t (:foreground "burlywood3"))))
 '(font-lock-variable-name-face ((t (:foreground "burlywood3"))))
 '(cursor ((t (:background "#00ff00"))))
 '(hl-line ((t (:inherit default :extend t :background "midnight blue"))))
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#161616" :foreground "burlywood3" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 113 :width normal :foundry "GOOG" :family "Noto Sans Mono")))))

(provide-theme 'werkor)
