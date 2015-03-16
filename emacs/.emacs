;; author: gnulot
;; e-mail: gnulot@126.com

(load-theme 'tsdh-dark)
(fset 'yes-or-no-p 'y-or-n-p)
(show-paren-mode t)
(setq show-paren-style 'parentheses)
(setq-default make-backup-files nil)
(setq x-select-enable-clipboard t)
(setq track-eol t)
(global-set-key (kbd "M-g") 'goto-line)
(global-linum-mode t)
(setq linum-format "%5d| ")
(setq-default tab-width 4)
;;ido
(add-to-list 'load-path "~/.emacs.d/plugins/ido-mode-el")
(require 'ido)

;;ace-jump-mode
(add-to-list 'load-path "~/.emacs.d/plugins/ace-jump-mode")
(require 'ace-jump-mode)
(autoload
  'ace-jump-mode
  "ace-jump-mode" t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))

(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

;; auto complete
(add-to-list 'load-path "~/.emacs.d/plugins/popup-el")
(add-to-list 'load-path "~/.emacs.d/plugins/fuzzy-el")
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete")
(require 'auto-complete-config)
(ac-config-default)

;; auto complete clang
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete-clang")
(require 'auto-complete-clang)
(setq ac-clang-auto-save t)
(setq ac-auto-start t)
(setq ac-quick-help-delay 0.5)
;; (ac-set-trigger-key "TAB")
;; (define-key ac-mode-map  [(control tab)] 'auto-complete)
(define-key ac-mode-map  [(control tab)] 'auto-complete)
(defun my-ac-config ()
  (setq ac-clang-flags
	(mapcar(lambda (item)(concat "-I" item))
	       (split-string
		                "  
 /usr/local/include
 /usr/include

")))
  (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
  (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
  (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
  (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
  (add-hook 'css-mode-hook 'ac-css-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))
(defun my-ac-cc-mode-setup ()
  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
;; ac-source-gtags
(my-ac-config)

(global-set-key "%" 'match-paren)
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	(t (self-insert-command (or arg 1)))))

(defun gnulot-mark-line (&optional arg)
  (interactive "P")
  (if (region-active-p)
      (progn
	(goto-char (line-end-position 2)))
    (progn
      (back-to-indentation)
      (set-mark (point))
      (goto-char (line-end-position))))
  (setq arg (if arg (prefix-numeric-value arg)
	      (if (< (mark) (point)) -1 1)))
  (if (and arg (> arg 1))
      (progn
	(goto-char (line-end-position arg)))))

(global-set-key (kbd "C-l") 'gnulot-mark-line)
