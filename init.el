;undo buffer limit
(setq undo-limit 40000000000)
(setq undo-strong-limit 400000000)

;change font
(add-to-list 'default-frame-alist '(font . "JetBrains Mono-10"))

;make cursor a box
(setq cursor-type 'box)
;make cursor on windows be a block 
(setq w32-use-visible-system-caret nil)
;determine underlying OS
(setq is-linux (equal system-type 'gnu/Linux))
(setq is-windows (equal system-type 'windows-nt))

;disable the bell
(setq ring-bell-function 'ignore)

;smooth scroll
(setq scroll-step 3)

;menu bar mode
(menu-bar-mode 0)

 ;tool bar mode
(tool-bar-mode 0)

;scroll bar mode
(scroll-bar-mode 0)

;load theme
(load-theme 'werkor t)

;show paren-mode
(show-paren-mode -1)
;(setq show-paren-style 'parenthesis)

;window options
(setq next-line-asj-newlines nil)
(setq-default truncate-lines nil)
(setq truncate-partial-width-windows nil)
(setq split-height-threshold nil)
(setq split-width-threshold 0)

;line numbers
(global-display-line-numbers-mode 1)

;line wrapping
;(global-visual-line-mode 1)
;(setq word-wrap t)
;(add-hook 'text-mode-hook #'refill-mode)
;(add-hook 'prog-mode-hook #'refill-mode)
;(setq-default fill-column 60) 

;mics packages
(require 'ido)
(require 'cc-mode)
(require 'compile)
(ido-mode t)
(require 'cc-mode)

;keybinds
;TODO(werkor):Bind(s?) are breaking M-x so figure out which one(s).
(global-set-key (kbd "C-e") 'other-window)
(global-set-key (kbd "M-f") 'find-file)
(global-set-key (kbd "M-F") 'find-file-other-window)
(global-set-key (kbd "M-s") 'werkor-save-buffer)
(global-set-key (kbd "M-b") 'ido-switch-buffer)
(global-set-key (kbd "M-B") 'ido-switch-buffer-other-window)
;(global-set-key (kbd "M-n") 'next-error)
;(global-set-key (kbd "M-p") 'previous-error)
(global-set-key (kbd "C-.") 'imenu)
(global-set-key (kbd "C-<") 'start-kbd-macro)
(global-set-key (kbd "C->") 'end-kbd-macro)
(global-set-key (kbd "C-r") 'call-last-kbd-macro)
(global-set-key (kbd "C-,") 'fill-paragraph)
(global-set-key (kbd "C-`") 'goto-line)
(global-set-key (kbd "C-y") 'revert-buffer)
(global-set-key (kbd "C-l") 'kill-this-buffer)
(global-set-key [escape] nil)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
;(global-set-key (kbd "<tab>") 'indent-for-tab-command)

;specific mode bindings

;c-style-modes
;(define-key c-mode-base-map (kbd "<tab>") 'c-indent-line-or-region)

;init package sources
(require 'package)

;(setq package-archives '(("melpa" . "https://melpa.org/packages/")
;                         ("elpa" . "https://elpa.gnu.org/packages/")))


(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;non-linux initialization
;(unless (package-installed-p 'use-package)
;        (package-install 'use-package))

;(require 'use-package)
;(setq use-package-always-ensure t)

;;;;;;;;;;;;;;;;;;;;
;;;;;functions;;;;;;
;;;;;;;;;;;;;;;;;;;;

(defun wekor-replace-in-region (old-word new-word)
	"Perform a replace-string in the current region"
	(interactive "sReplace: \nsReplace : %s With: ")
	(save-excursion (save-restriction
									(narrow-to-region (mark) (point))
									(beginning-of-buffer)
									(replace-string old-word new-word)
									))
)
(global-set-key (kbd "C-l") 'werkor-replace-in-region)
(global-set-key (kbd "C-o") 'query-replace)

(defun display-buffer-2-windows (buffer alist)
	"If only one window is available split it and display BUFFER there.
	Alist is the only option channel for display actions (see 'dsiplay-buffer')."
	(when (eq (length (window-list nil 'no-minibuf)) 1)
		(display-buffer--maybe-pop-up-window buffer alist)))

(setq display-buffer-base-action
	'((display-buffer--maybe-same-window
			display-buffer-reuse-window
			display-buffer--maybe-pop-up-frame
			display-buffer-2-windows
			display-buffer-in-previous-window
			display-buffer-use-some-window
			display-buffer-pop-up-frame)))

(defun werkor-split-window ()
	"Dont split windows"
	nil)
(setq split-window-preffered-function 'werkor-split-window)

(defun append-as-kill ()
	"performs copy-region-as-kill as an append."
	(interactive)
	(append-next-kill)
	(copy-region-as-kill (mark) (point))
)
(global-set-key (kbd "C-q") 'append-as-kill)
(global-set-key (kbd "C-a") 'yank)
(global-set-key (kbd "C-z") 'kill-region)
(global-set-key (kbd "C-:") 'view-back-to-mark)
(global-set-key (kbd "C-;") 'exchange-point-and-mark)


;save buffer function
(defun werkor-save-buffer ()
        "Save the buffer after untabifying it."
        (interactive)
        (save-excursion
                (save-restriction
                        (widen)
                        (untabify (point-min) (point-max))))
        (save-buffer))

;find headerfile (c style only)
(defun werkor-find-corresponding-file ()
	"Find the file that corresponds the this one."
	(interactive)
	(setq CorrespondingFileName nil)
	(setq BaseFileName (file-name-sans-extension buffer-file-name))
	(if (string-match "\\.c" buffer-file-name)
		(setq CorrespondingFileName (concat BaseFileName ".h")))
	(if (string-match "\\.h" buffer-file-name)
		(if (file-exists-p (concat BaseFileName ".c")) (setq CorrespondingFileName (concat BaseFileName ".c"))
			(setq CorrespondingFileName (concat BaseFileName ".cpp"))))
	(if (string-match "\\.hin" buffer-file-name)
		(setq CorrespondingFileName (concat BaseFileName ".cin")))
	(if (string-match "\\.cin" buffer-file-name)
		(setq CorrespondingFileName (concat BaseFileName ".hin")))
	(if (string-match "\\.cpp" buffer-file-name)
		(setq CorrespondingFileName (concat BaseFileName ".h")))
	(if CorrespondingFileName (find-file CorrespondingFileName)
		(error "Unable to find a corresponding file")))

(defun werkor-find-corresponding-file-other-window ()
	"Find the file that corresponds to this one.(other window)"
	(interactive)
	(find-file-other-window buffer-file-name)
	(werkor-find-corresponding-file)
	(other-window -1))
(define-key c-mode-base-map (kbd "M-I") 'werkor-find-corresponding-file)
(define-key c-mode-base-map (kbd "M-i") 'werkor-find-corresponding-file-other-window)

;compile mode stuff
(defun compilation-line-hook ()
        (make-local-variable 'truncate lines)
        (setq truncate lines nil)
)
(add-hook 'compilation-mode-hook 'compilation-line-hook)

;compile stuff
(setq werkor-makefile "build.sh")
(when is-windows
        (setq werkor-makefile "build.bat")
)

(defun make-without-asking ()
        "make the current build"
        (interactive)
        (if (find-project-directory) (compile werkor-makefile))
        (other-window 1)
 (global-set-key (kbd "M-m") 'make-without-asking)     
)

;project directory stuff
(setq compilation-directory-locked nil)

(defun find-project-directory-recursive ()
        "recursively search for a makefile."
        (interactive)
        (if (file-exists-p werkor-makefile) t
                (cd "../")
		(setq my-current-directory default-directory)
		(message "The Current working directory is: %s" default-directory)
                (find-project-directory-reursive)))

(defun lock-compilation-directory ()
        "the compilation process should NOT look for a makefile"
        (interactive)
        (setq compilation-directory-locked t)
        (message "Compilation directory is locked"))

(defun unlock-compilation-directory ()
        (interactive)
        (setq compilation-directory-locked nil)
        (message "Compilation directory is roaming"))


(defun find-project-directory ()
        "find the project directory"
        (interactive)
        (setq find-project-from-directory default directory)
        (switch-to-buffer-other-window "*compilation")
        (if compilation-directory-locked (cd last-compilation-directory)
        (cd find-project-from-directory)
        (find-project-directory-recursive)
        (setq last-compilation-directory default-directory)))

;post-loading settings
(defun post-load-stuff ()
	(interactive)
	(split-window-right)
	(setq split-height-threshold nil)
	(setq split-width-threshold 0)
)
(add-hook'window-setup-hook 'post-load-stuff t)

;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; end functions;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;magit
;(use-package magit)

;forge
;(use-package forge
;     :after magit)

;set token path
;(setq auth-sources '("~/.authinfo.gpg")) 

;theme
;(set-face-attribute 'font-lock-builtin-face nil :foreground "#DAB98F")
;(set face-attribute 'font-lock-comment-face nil :foreground "gray50")
;(set-face-attribute 'font-lock-constant-face nil :foreground "olive drab")
;(set-face-attribute 'font-lock-doc-face nil :foreground "gray50")
;(set-face-attribute 'font-lock-function-name-face nil :foreground "burlywood3")
;(set-face-attribute 'font-lock-keyword-face nil :forground "DarkGoldenrod3")
;(set-face-attribute 'font-lock-string-face nil :foreground "olive drab")
;(set-face-attribute 'font-lock-type-face nil :foreground "burlywood3")
;(set-face-attribute 'font-lock-variable-name-face nil :foreground "burlywood3")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("79aabf6cceedb08f569b45bfe4987b074c19c679cd93ea86c93708f667d455f0"
     "3d39093437469a0ae165c1813d454351b16e4534473f62bc6e3df41bb00ae558"
     default))
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
 
