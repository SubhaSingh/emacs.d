(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages
  '(;; Basic
    flx-ido
    magit
    github-browse-file
    projectile
    noctilux-theme
    auto-highlight-symbol
    color-identifiers-mode
    dired+
    smex
    ace-jump-mode
    aggressive-indent
    ;; Clojure
    clojure-mode
    cider
    clj-refactor
    smartparens
    rainbow-delimiters
    ac-cider))

(dolist (p my-packages)
  (unless (package-installed-p p)
    (package-install p)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Behaviour

(setq initial-scratch-message "")

;; Save when out of focus
(defun save-all ()
  (interactive)
  (save-some-buffers t))

(add-hook 'focus-out-hook 'save-all)

(global-linum-mode t)
(setq make-backup-files nil)
(global-auto-complete-mode)
(global-auto-highlight-symbol-mode)
(diredp-toggle-find-file-reuse-dir 1)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(defalias 'yes-or-no-p 'y-or-n-p)
(setq ring-bell-function 'ignore)
(scroll-bar-mode -1)

;; No Start Screen
(setq inhibit-startup-message t)

(delete-selection-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Custom functions

(defun kill-all-buffers ()
  "Kill all buffers"
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; General keybinds

(global-set-key [f12] (lambda () (interactive) (find-file "~/.emacs.d/init.el")))

(global-set-key (kbd "C-c q") 'join-line)

(global-set-key [?\C-x ?\C-x] 'other-window)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Theme

(load-theme 'noctilux t)

(require 'paren)
(set-face-foreground 'show-paren-match "purple")
(set-face-background 'show-paren-match "#98D9D4")
(set-face-attribute 'show-paren-match nil :weight 'bold)

;; FIRACODE
(when (and (window-system) (find-font (font-spec :name "Fira Code")))
  (add-to-list 'default-frame-alist '(font . "Fira Code 13" )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Flx-ido

(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Smex

(require 'smex)
(smex-initialize)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Yasnippet

(require 'yasnippet)
(yas-reload-all)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Magit

(global-set-key [?\C-c ?\g] 'magit-status)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load keybindings
(load (concat user-emacs-directory "keybinds.el"))

(when (file-exists-p (concat user-emacs-directory "private-keybinds.el"))
  (load (concat user-emacs-directory "private-keybinds.el")))

;; Save when out of focus
(defun save-all ()
  (interactive)
  (save-some-buffers t))

(add-hook 'focus-out-hook 'save-all)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Projectile

(require 'projectile)

(projectile-global-mode)

(global-set-key [f9] (lambda ()
                       (interactive)
                       (find-file (expand-file-name "dev/user.clj" (projectile-project-root)))))
(global-set-key [f10] (lambda ()
                        (interactive)
                        (find-file (expand-file-name "project.clj" (projectile-project-root)))))


(define-key projectile-mode-map [?\s-d] 'projectile-find-dir)
(define-key projectile-mode-map [?\s-p] 'projectile-switch-project)
(define-key projectile-mode-map [?\s-f] 'projectile-find-file)
(define-key projectile-mode-map [?\s-g] 'projectile-grep)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Smartparens

(require 'smartparens)

(sp-local-pair 'clojure-mode "'" nil :actions nil)
(sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)

(define-key smartparens-mode-map [?\C-\)] 'sp-forward-slurp-sexp)
(define-key smartparens-mode-map [?\C-\(] 'sp-backward-slurp-sexp)
(define-key smartparens-mode-map [?\M-r] 'sp-raise-sexp)

(defun my-wrap-with-paren (&optional arg)
  (interactive "p")
  (sp-select-next-thing-exchange arg)
  (execute-kbd-macro (kbd "(")))

(define-key smartparens-mode-map [?\M-\(] 'my-wrap-with-paren)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Emacs lisp mode

(add-hook 'emacs-lisp-mode-hook #'smartparens-strict-mode)
(add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Clojure mode

(add-hook 'clojure-mode-hook #'subword-mode)
(add-hook 'clojure-mode-hook #'smartparens-strict-mode)
(add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)
;; (add-hook 'clojure-mode-hook #'aggressive-indent-mode)

(defun my-clojure-mode-hook ()
  (clj-refactor-mode 1)
  (yas-minor-mode 1) ; for adding require/use/import statements
  ;; This choice of keybinding leaves cider-macroexpand-1 unbound
  (cljr-add-keybindings-with-prefix "s-r")
  (hs-minor-mode 1)
  (show-paren-mode 1)
  (auto-highlight-symbol-mode 1)
  (color-identifiers-mode 1))

(add-hook 'clojure-mode-hook #'my-clojure-mode-hook)

(setq clojure-align-forms-automatically t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; CIDER

(require 'cider)
(add-hook 'cider-mode-hook #'eldoc-mode)
(setq nrepl-buffer-name-show-port t)
(setq cider-lein-command "/usr/local/bin/lein")

;; cf Cider doc
(require 'ac-cider)
(add-hook 'cider-mode-hook 'ac-flyspell-workaround)
(add-hook 'cider-mode-hook 'ac-cider-setup)
(add-hook 'cider-repl-mode-hook 'ac-cider-setup)
(eval-after-load "auto-complete"
  '(progn
     (add-to-list 'ac-modes 'cider-mode)
     (add-to-list 'ac-modes 'cider-repl-mode)))

(defun set-auto-complete-as-completion-at-point-function ()
  (setq completion-at-point-functions '(auto-complete)))

(add-hook 'cider-repl-mode-hook #'eldoc-mode)
(setq cider-cljs-lein-repl
      "(do (require 'figwheel-sidecar.repl-api)
           (figwheel-sidecar.repl-api/start-figwheel!)
           (figwheel-sidecar.repl-api/cljs-repl))")

(defun cider-repl-reset-basic (force)
  (interactive "P")
  (save-some-buffers)
  (when force
    (find-project-file "dev/user.clj")
    (cider-load-buffer))
  (with-current-buffer (cider-current-repl-buffer)
    (goto-char (point-max))
    (insert "(user/reset-basic)")
    (cider-repl-return)))

(defun cider-repl-reset (force)
  (interactive "P")
  (save-some-buffers)
  (when force
    (find-project-file "dev/user.clj")
    (cider-load-buffer))
  (with-current-buffer (cider-current-repl-buffer)
    (goto-char (point-max))
    (insert "(user/reset)")
    (cider-repl-return)))

(define-key clojure-mode-map (kbd "C-c r") 'cider-repl-reset)
(define-key clojure-mode-map (kbd "C-c R") 'cider-repl-reset-basic)

(define-key cider-repl-mode-map (kbd "C-c r") 'cider-repl-reset)
(define-key cider-repl-mode-map (kbd "C-c R") 'cider-repl-reset-basic)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Custom-set variables

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (ac-cider rainbow-delimiters paxedit clj-refactor cider clojure-mode aggressive-indent ace-jump-mode smex dired+ color-identifiers-mode auto-highlight-symbol noctilux-theme projectile github-browse-file magit flx-ido)))
 '(sp-highlight-pair-overlay nil)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cider-result-overlay-face ((t (:foreground "PaleTurquoise1"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "pale turquoise")))))

(server-start)
