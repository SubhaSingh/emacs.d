(global-set-key [f7] 'cider-create-sibling-cljs-repl)
(global-set-key [f8] 'cider-connect)
(global-set-key [M-f8] 'cider-quit)

(global-set-key [f11] (lambda () (interactive) (find-file "~/.lein/profiles.clj")))
(global-set-key [f12] (lambda () (interactive) (find-file "~/.emacs.d/keybinds.el")))
(global-set-key [M-f12] (lambda () (interactive) (find-file "~/.emacs.d/init.el")))

(global-set-key [?\C-c ?\g] 'magit-status)

(global-set-key [?\C-.] 'hs-toggle-hiding)
(global-set-key [?\C-,] 'hs-hide-all)
(global-set-key [?\C-x ?\C-,] 'hs-show-all)

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

(global-set-key (kbd "C-c R") 'cider-repl-reset-basic)
(global-set-key (kbd "C-c r") 'cider-repl-reset)
(global-set-key (kbd "C-c e") 'cider-enlighten-mode)

(require 'projectile)

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

(global-set-key (kbd "C-c q") 'join-line)

(require 'paxedit)

(eval-after-load "paxedit"
  '(progn
     (define-key paxedit-mode-map (kbd "C-M-<right>") 'paxedit-transpose-forward)
     (define-key paxedit-mode-map (kbd "C-M-<left>") 'paxedit-transpose-backward)
     (define-key paxedit-mode-map (kbd "C-M-<up>") 'paxedit-backward-up)
     (define-key paxedit-mode-map (kbd "C-M-<down>") 'paxedit-backward-end)
     (define-key paxedit-mode-map (kbd "M-b") 'paxedit-previous-symbol)
     (define-key paxedit-mode-map (kbd "M-f") 'paxedit-next-symbol)
     (define-key paxedit-mode-map (kbd "C-%") 'paxedit-copy)
     (define-key paxedit-mode-map (kbd "C-&") 'paxedit-kill)
     (define-key paxedit-mode-map (kbd "C-*") 'paxedit-delete)
     (define-key paxedit-mode-map (kbd "C-^") 'paxedit-sexp-raise)
     (define-key paxedit-mode-map (kbd "M-u") 'paxedit-symbol-change-case)
     (define-key paxedit-mode-map (kbd "C-@") 'paxedit-symbol-copy)
     (define-key paxedit-mode-map (kbd "C-#") 'paxedit-symbol-kill)))

(defun win-resize-top-or-bot ()
  "Figure out if the current window is on top, bottom or in the
middle"
  (let* ((win-edges (window-edges))
         (this-window-y-min (nth 1 win-edges))
         (this-window-y-max (nth 3 win-edges))
         (fr-height (frame-height)))
    (cond
     ((eq 0 this-window-y-min) "top")
     ((eq (- fr-height 1) this-window-y-max) "bot")
     (t "mid"))))

(defun win-resize-left-or-right ()
  "Figure out if the current window is to the left, right or in the
middle"
  (let* ((win-edges (window-edges))
         (this-window-x-min (nth 0 win-edges))
         (this-window-x-max (nth 2 win-edges))
         (fr-width (frame-width)))
    (cond
     ((eq 0 this-window-x-min) "left")
     ((eq (+ fr-width 4) this-window-x-max) "right")
     (t "mid"))))

(defun win-resize-enlarge-vert ()
  (interactive)
  (cond
   ((equal "top" (win-resize-top-or-bot)) (enlarge-window -5))
   ((equal "bot" (win-resize-top-or-bot)) (enlarge-window 5))
   ((equal "mid" (win-resize-top-or-bot)) (enlarge-window -5))
   (t (message "nil"))))

(defun win-resize-minimize-vert ()
  (interactive)
  (cond
   ((equal "top" (win-resize-top-or-bot)) (enlarge-window 5))
   ((equal "bot" (win-resize-top-or-bot)) (enlarge-window -5))
   ((equal "mid" (win-resize-top-or-bot)) (enlarge-window 5))
   (t (message "nil"))))

(defun win-resize-enlarge-horiz ()
  (interactive)
  (cond
   ((equal "left" (win-resize-left-or-right)) (enlarge-window-horizontally -30))
   ((equal "right" (win-resize-left-or-right)) (enlarge-window-horizontally 30))
   ((equal "mid" (win-resize-left-or-right)) (enlarge-window-horizontally 30))))

(defun win-resize-minimize-horiz ()
  (interactive)
  (cond
   ((equal "left" (win-resize-left-or-right)) (enlarge-window-horizontally 30))
   ((equal "right" (win-resize-left-or-right)) (enlarge-window-horizontally -30))
   ((equal "mid" (win-resize-left-or-right)) (enlarge-window-horizontally -30))))

(global-set-key [?\C-x ?\C-x] 'other-window)

(global-set-key [s-S-left] 'win-resize-enlarge-horiz)
(global-set-key [s-S-right] 'win-resize-minimize-horiz)
(global-set-key [s-S-up] 'win-resize-enlarge-vert)
(global-set-key [s-S-down] 'win-resize-minimize-vert)

;; Move active cursor to window
(global-set-key [s-left] 'windmove-left)
(global-set-key [s-right] 'windmove-right)
(global-set-key [s-up] 'windmove-up)
(global-set-key [s-down] 'windmove-down)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

(global-set-key "\C-x\C-b" 'buffer-menu)
(global-set-key (kbd "C-M-y") 'yas-expand)

(global-set-key [?\C-c ?b] 'github-browse-file)

(global-set-key [?\M-\[] 'paredit-wrap-square)
(global-set-key [?\M-{] 'paredit-wrap-curly)
(global-set-key [?\M-#] 'replace-regexp)

(defun nl-form ()
  (interactive)
  (newline)
  (indent-according-to-mode)
  (paredit-open-round))

(defun open-next-form ()
  (interactive)
  (paredit-forward-up)
  (nl-form))

(defun open-next-square ()
  (interactive)
  (paredit-forward-up)
  (newline)
  (indent-according-to-mode)
  (paredit-open-square)})

(global-set-key [?\C-'] 'nl-form)
(global-set-key [?\M-'] 'open-next-form)
(global-set-key [?\C-\;] 'open-next-square)

(global-set-key [?\C-\\] 'ace-jump-mode)
(global-set-key [?\M-\\] 'ace-jump-line-mode)

(defun kill-all-buffers ()
  "Kill all buffers"
  (interactive)
  (mapc 'kill-buffer (buffer-list)))
