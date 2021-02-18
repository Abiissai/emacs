;; [[file:~/config-shared/.emacs.d/init.org::*All-the-icons][All-the-icons:1]]
(use-package all-the-icons)
;; All-the-icons:1 ends here

;; [[file:~/config-shared/.emacs.d/init.org::*Ivy%20all-the-icons][Ivy all-the-icons:1]]
(use-package all-the-icons-ivy
:init (all-the-icons-ivy-setup)
)
;; Ivy all-the-icons:1 ends here

;; [[file:~/config-shared/.emacs.d/init.org::*Dired%20all-the-icons][Dired all-the-icons:1]]
(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))
;; Dired all-the-icons:1 ends here






(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
(global-display-line-numbers-mode t)


(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)


;; C/C++
(defun compileandruncpp()
  (interactive)
  (save-buffer)
  (let* ((src (file-name-nondirectory (buffer-file-name)))
         (exe (file-name-sans-extension src)))
    (compile (concat "clang++ " src " -o " exe " && ./" exe)))
  (other-window 1)
  (end-of-buffer))

;; now add a hook to de c++-mode and add the key f8 to invoke compileandrun(up code)
(add-hook 'c++-mode-hook
          (lambda () (local-set-key (kbd "<f8>") #'compileandruncpp)))

;; now in your code cpp press f8, see the compile and execute
;; to close the window(compile and execute)
;; press q key :-)


(defun compileandrunc()
  (interactive)
  (save-buffer)
  (let* ((src (file-name-nondirectory (buffer-file-name)))
	 (exe (file-name-sans-extension src)))
    (compile (concat "clang " src " -o " exe " && ./" exe)))
  (other-window 1)
  (end-of-buffer))

;; now add a hook to de c-mode and add the key f8 to invoke compileandrun(up code)
(add-hook 'c-mode-hook
	  (lambda () (local-set-key (kbd "<f8>") #'compileandrunc)))



(defvar xgp-cfsi-left-PAREN-old nil
  "Command used to input \"(\"")
(make-variable-buffer-local 'xgp-cfsi-left-PAREN-old)

(defun xgp-cfsi-modify-alist (alist term new)
  (let ((tl (assq term (symbol-value alist))))
    (if tl
        (setcdr tl new)
      (add-to-list alist (cons term new)))))

(defun xgp-cfsi (style)
  "Deciding whether using CFSI."
  (interactive "Style: ")
  (c-set-style style)
  (setq indent-tabs-mode
        nil
        c-hanging-semi&comma-criteria
        (quote (c-semi&comma-inside-parenlist)))

  (xgp-cfsi-modify-alist 'c-hanging-braces-alist 'class-open nil)
  (xgp-cfsi-modify-alist 'c-hanging-braces-alist 'class-close nil)
  (local-set-key " " 'self-insert-command))

(defun xgp-cfsi-erase-blanks ()
  "Erase all trivial blanks for CFSI."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "[ \t]+$" nil t)
      (replace-match "" nil nil))))

(defun linux-c-mode()
  (define-key c-mode-map [return] 'newline-and-indent)
  (setq imenu-sort-function 'imenu--sort-by-name)
  (interactive)
  (imenu-add-menubar-index)
  (which-function-mode)
  (c-toggle-auto-state)
  (c-toggle-hungry-state)
  (setq indent-tabs-mode nil)
  (xgp-cfsi "linux"))
(add-hook 'c-mode-common-hook 'linux-c-mode)

(add-hook 'c-mode-hook 'company-mode)
(add-hook 'c++-mode-hook 'company-mode)


;; Auto completion
(use-package auto-complete
:ensure t
:init
(progn
(ac-config-default)
(global-auto-complete-mode t)
))


;; on the fly syntax checking
(use-package flycheck
:ensure t
:init
(global-flycheck-mode t))

;; snippets and snippet expansion
(use-package yasnippet
:ensure t
:init
(yas-global-mode 1))


;; tags for code navigation
(use-package ggtags
:ensure t
:config
(add-hook 'c-mode-common-hook
(lambda ()
(when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
(ggtags-mode 1))))
)
;;;; --------------------------------C-C++++++++++++++++++++++++++++++++++++

;;;; -------------------------------ACE_WINDIW-----------------------------
(use-package ace-window
  :ensure t
  :bind
  ("C-x o" . ace-window)
  :config
  (setq aw-keys '(?a ?s ?d ?f)))

;;---------------------------------COMPANY------------------------------------
(use-package company)
(add-hook 'after-init-hook 'global-company-mode)

;;---------------------------------Web-Mode----------------------------------
;; WEB-MODE
(use-package web-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (setq web-mode-engines-alist
	'(("django"  . "\\.html\\'")))
  (setq web-mode-ac-sources-alist
	'(("css" . (ac-source-css-property))
          ("html" . (ac-source-work-in-buffer ac-source-abbrev))))
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-auto-quoting t))

  
(setq web-mode-enable-current-column-highlight t)
(setq web-mode-enable-current-element-highlight t)

;;_----------------------------------Emmet------------------------------------
(use-package emmet-mode)
(add-hook 'web-mode-hook  'emmet-mode)

(add-hook 'web-mode-before-auto-complete-hooks
    '(lambda ()
     (let ((web-mode-cur-language
  	    (web-mode-language-at-pos)))
               (if (string= web-mode-cur-language "php")
    	   (yas-activate-extra-mode 'php-mode)
      	 (yas-deactivate-extra-mode 'php-mode))
               (if (string= web-mode-cur-language "css")
    	   (setq emmet-use-css-transform t)
      	 (setq emmet-use-css-transform nil)))))

;;==-----------------------------------------------------------------------
(use-package multiple-cursors
  :ensure t
  :bind (
	 ("M-," . mc/mark-next-like-this)
	 ("M-i" . mc/mark-previous-like-this)
	 ("C-c z" . mc/mark-all-like-this)))
	

;;-------------------------------------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#18181B" "#cd5c60" "#6fb593" "#dbac66" "#41b0f3" "#cea2ca" "#6bd9db" "#e4e4e8"])
 '(cursor-type 'bar)
 '(custom-enabled-themes '(atom-one-dark))
 '(custom-safe-themes
   '("5b7c31eb904d50c470ce264318f41b3bbc85545e4359e6b7d48ee88a892b1915" "e1ef2d5b8091f4953fe17b4ca3dd143d476c106e221d92ded38614266cea3c8b" "d0aa1464d7e55d18ca1e0381627fac40229b9a24bca2a3c1db8446482ce8185e" "37768a79b479684b0756dec7c0fc7652082910c37d8863c35b702db3f16000f8" "eb122e1df607ee9364c2dfb118ae4715a49f1a9e070b9d2eb033f1cefd50a908" "1f35dedbeacbfe9ed72810478836105b5617da67ca27f717a29bbb8087e8a1ba" "1f6039038366e50129643d6a0dc67d1c34c70cdbe998e8c30dc4c6889ea7e3db" "ff4d091b20e9e6cb43954e4eeae1c3b334e28b5923747c7bd5d2720f2a67e272" "171d1ae90e46978eb9c342be6658d937a83aaa45997b1d7af7657546cae5985b" "1d717599e366ea10ae63d9e643f3c642d7f36bc8ba67fe651d4496a26ebe7f94" default))
 '(fci-rule-color "#3E4451")
 '(package-selected-packages
   '(multiple-cursors all-the-icons-ivy all-the-icons-dired all-the-icons atom-one-dark-theme flatland-theme flatland-black-theme yasnippet web-mode use-package ggtags flycheck emmet-mode company auto-complete ace-window))
 '(pos-tip-background-color "#222225")
 '(pos-tip-foreground-color "#c8c8d0")
 '(tetris-x-colors
   [[229 192 123]
    [97 175 239]
    [209 154 102]
    [224 108 117]
    [152 195 121]
    [198 120 221]
    [86 182 194]])
 '(vc-annotate-background "#1f2124")
 '(vc-annotate-color-map
   '((20 . "#ff0000")
     (40 . "#ff4a52")
     (60 . "#f6aa11")
     (80 . "#f1e94b")
     (100 . "#f5f080")
     (120 . "#f6f080")
     (140 . "#41a83e")
     (160 . "#40b83e")
     (180 . "#b6d877")
     (200 . "#b7d877")
     (220 . "#b8d977")
     (240 . "#b9d977")
     (260 . "#93e0e3")
     (280 . "#72aaca")
     (300 . "#8996a8")
     (320 . "#afc4db")
     (340 . "#cfe2f2")
     (360 . "#dc8cc3")))
 '(vc-annotate-very-old-color "#dc8cc3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
