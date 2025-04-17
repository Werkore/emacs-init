 ;tool bar mode
(tool-bar-mode 0)

;scroll bar mode
(scroll-bar-mode -1)

;window options

(split-window-right)
(add-to-list 'default-frame-alist '(fullscreen , maximized))
 
;line numbers
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers mode 0))))


;load theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'handmade t)


;esc for global prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)


;init package sources
(require 'package)



(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))


(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;non-linux initialization
(unless (package-installed-p 'use-package)
	(package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;rainbow delimiter
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;doom modeline
(use-package doom-modeline
  :ensure t
  :init(doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

;doom-themes
(use-package doom-themes)

;all-the-icons
(use-package all-the-icons)

;ivy
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))
	  

;whichkey
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;general
(use-package general
  :config
  (general-create-definer rune/leader-keys
			  :keymaps '(normal insert visual emacs)
			  :prefix "SPC"
			  :global-prefix "C-SPC")
  (rune/leader-keys
   "t" '(:ignore t :whiche-key "toggles")))

  
;evil mode
(defun rune/evil-hook ()
  (dolist (mode '(custom-mode
		  eshell-mode
		  git-rebase-mode
		  erc-mode
		  circle-server-mode
		  circle-chat-mode
		  circle-query-mode
		  sauron-mode
		  term-mode))
    (add-to-list 'evil-emacs-state-modes mode)))
		
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1))

;evil visual line motions outside of visual mode
(evil-global-set-key 'motion "j" 'evil-next-visual-line)
(evil-global-set-key 'motion "k" 'evil-previous-visual-line)

(evil-set-initial-state 'messages-buffer-mode 'normal)
(evil-set-initial-state 'dashboard-mode 'normal)

;evil collection
(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;hydra
(use-package hydra)

(use-package hydra)
(defhydra hydra-text-scale (:timeout 4)
	  "scale text"
	  ("j" text-scale-increase "in")
	  ("k" text-scale-decrease "out")
	  ("f" nil "finished" :exit t))
(rune/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale-text"))

;prjectile
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/projects/code")
    (setq projectile-project-search-path '(("~projects/code")))
    (setq projectile-switch-project-action #' projectile-dired)))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;magit
(use-package magit
  :commands (magit-status magit-get-current-branch))
;  :custom
;  (magit-display-buffer-function #' magit-display-same-buffer-window-except-diffv1))

;set token path
(setq auth-sources '("~/.authinfo.gpg")) 

;forge
(use-package forge)
 
;ghub
(use-package ghub)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("3d39093437469a0ae165c1813d454351b16e4534473f62bc6e3df41bb00ae558" default))
 '(package-selected-packages '(ivy hydra which-key doom-modeline rainbow-delimiters)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
 
