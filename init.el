;; -*- lexical-binding: t; -*-
;; NOTE: init.el is now generated from Emacs.org.  Please edit that file in
;;       Emacs and init.el will be generated automatically!

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 16777216 ; 16mb
                  gc-cons-percentage 0.1)))

(defun doom-defer-garbage-collection-h ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun doom-restore-garbage-collection-h ()
  ;; Defer it so that commands launched immediately after will enjoy the
  ;; benefits.
  (run-at-time
   1 nil (lambda () (setq gc-cons-threshold 16777216)))) ; 16mb

(add-hook 'minibuffer-setup-hook #'doom-defer-garbage-collection-h)
(add-hook 'minibuffer-exit-hook #'doom-restore-garbage-collection-h)

(defvar doom--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Alternatively, restore it even later:
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist doom--file-name-handler-alist)))

;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

(add-hook
 'after-init-hook
 (lambda ()
   (let ((private-file (concat user-emacs-directory "private.el")))
     (when (file-exists-p private-file)
       (load-file private-file)))))

;; Keep backup files and auto-save files in the backups directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups" user-emacs-directory)))
      auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save-list/" user-emacs-directory) t)))

(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file 'noerror)

(setq straight-use-package-by-default t
      straight-build-dir (format "build-%s" emacs-version))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
;;(setq use-package-always-defer t)

(mac-auto-operator-composition-mode)

(setq-default delete-by-moving-to-trash t)

;; Both command keys are 'Super'
(setq mac-right-command-modifier 'super)
(setq mac-command-modifier 'super)

;; Option or Alt is naturally 'Meta'
(setq mac-option-modifier 'meta)
(setq mac-right-option-modifier 'meta)

;; Make keybindings feel natural on mac
(global-set-key (kbd "s-s") 'save-buffer)             ;; save
(global-set-key (kbd "s-S") 'write-file)              ;; save as
(global-set-key (kbd "s-q") 'save-buffers-kill-emacs) ;; quit
(global-set-key (kbd "s-a") 'mark-whole-buffer)       ;; select all
(global-set-key (kbd "s-k") 'kill-this-buffer)
(global-set-key (kbd "s-v") 'yank)
(global-set-key (kbd "s-c") 'kill-ring-save)
(global-set-key (kbd "s-z") 'undo)
(global-set-key (kbd "s-=") 'text-scale-adjust)
(global-set-key (kbd "s-+") 'text-scale-increase)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(global-set-key (kbd "C-M-u") 'universal-argument)

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump t)
  (setq evil-move-beyond-eol t)
  (setq evil-move-cursor-back nil)
  :custom
  (evil-undo-system 'undo-fu)
  (evil-symbol-word-search t)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-normal-state-map "\C-e" 'evil-end-of-line)
  (define-key evil-insert-state-map "\C-e" 'end-of-line)
  (define-key evil-visual-state-map "\C-e" 'evil-end-of-line)
  (define-key evil-motion-state-map "\C-e" 'evil-end-of-line)
  (define-key evil-normal-state-map "\C-y" 'yank)
  (define-key evil-insert-state-map "\C-y" 'yank)
  (define-key evil-visual-state-map "\C-y" 'yank)
  (define-key evil-normal-state-map "\C-k" 'kill-line)
  (define-key evil-insert-state-map "\C-k" 'kill-line)
  (define-key evil-visual-state-map "\C-k" 'kill-line)

  ;; Get around faster
  (define-key evil-motion-state-map "gs" 'evil-avy-goto-char-timer)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)

  ;; Let emacs bindings for M-. and M-, take over
  (define-key evil-normal-state-map (kbd "M-.") nil)
  (define-key evil-normal-state-map (kbd "M-,") nil)

  (global-set-key (kbd "s-w") 'evil-window-delete))

(use-package evil-collection
  :config
  (evil-collection-init))

;; Allows you to use the selection for * and #
(use-package evil-visualstar
  :commands (evil-visualstar/begin-search
             evil-visualstar/begin-search-forward
             evil-visualstar/begin-search-backward)
  :init
  (evil-define-key 'visual 'global
    "*" #'evil-visualstar/begin-search-forward
    "#" #'evil-visualstar/begin-search-backward))

(use-package general
  :config
  (general-create-definer dawran/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "M-SPC")

  (general-create-definer dawran/localleader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :major-modes t
    :prefix ","
    :non-normal-prefix "C-,")

  (dawran/leader-keys
    "fd" '((lambda () (interactive) (find-file (expand-file-name "~/.emacs.d/README.org"))) :which-key "edit config")
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(load-theme :which-key "choose theme")
    "tw" 'whitespace-mode
    "tm" 'toggle-frame-maximized
    "tM" 'toggle-frame-fullscreen))

(global-set-key (kbd "C-x C-b") #'ibuffer)
(global-set-key (kbd "C-M-j") #'switch-to-buffer)
(global-set-key (kbd "M-:") 'pp-eval-expression)

(global-set-key (kbd "s-t")
                #'(lambda ()
                    (interactive)
                    (switch-to-buffer (get-buffer-create "*scratch*"))))

(use-package blackout
  :straight (:host github :repo "raxod502/blackout"))

(use-package autorevert
  :defer t
  :blackout auto-revert-mode)

(use-package which-key
  :blackout t
  :hook (after-init . which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(setq inhibit-startup-message t)

(setq frame-inhibit-implied-resize t)

(setq default-frame-alist
      (append (list
               '(font . "Monolisa-14")
               '(min-height . 1) '(height     . 45)
               '(min-width  . 1) '(width      . 81)
               )))

;; No beeping nor visible bell
(setq ring-bell-function #'ignore
      visible-bell nil)

(blink-cursor-mode 0)

(setq-default fill-column 80)
(setq-default line-spacing 0.1)

(column-number-mode)

;; Enable line numbers for prog modes only
(add-hook 'prog-mode-hook (lambda () (display-line-numbers-mode 1)))

(use-package hl-line
  :hook
  (prog-mode . hl-line-mode))

(add-to-list 'load-path "~/.emacs.d/themes")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'oil6 t)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Monolisa" :height 140 :weight 'regular)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height 160 :weight 'regular)

;;;; Mode line

;; The following code customizes the mode line to something like:
;; [*] radian.el   18% (18,0)     [radian:develop*]  (Emacs-Lisp)

(defun my/mode-line-buffer-modified-status ()
  "Return a mode line construct indicating buffer modification status.
  This is [*] if the buffer has been modified and whitespace
  otherwise. (Non-file-visiting buffers are never considered to be
  modified.) It is shown in the same color as the buffer name, i.e.
  `mode-line-buffer-id'."
  (propertize
   (if (and (buffer-modified-p)
            (buffer-file-name))
       "[*]"
     "   ")
   'face 'mode-line-buffer-id))

;; Normally the buffer name is right-padded with whitespace until it
;; is at least 12 characters. This is a waste of space, so we
;; eliminate the padding here. Check the docstrings for more
;; information.
(setq-default mode-line-buffer-identification
              (propertized-buffer-identification "%b"))

;; Make `mode-line-position' show the column, not just the row.
(column-number-mode +1)

;; https://emacs.stackexchange.com/a/7542/12534
(defun my/mode-line-align (left right)
  "Render a left/right aligned string for the mode line.
  LEFT and RIGHT are strings, and the return value is a string that
  displays them left- and right-aligned respectively, separated by
  spaces."
  (let ((width (- (window-total-width) (length left))))
    (format (format "%%s%%%ds" width) left right)))

(defcustom my/mode-line-left
  nil
  "Composite mode line construct to be shown left-aligned."
  :type 'sexp)

(defcustom my/mode-line-right
  '(;; Show [*] if the buffer is modified.
    (:eval (my/mode-line-buffer-modified-status))
    " "
    ;; Show the name of the current buffer.
    mode-line-buffer-identification
    " "
    ;; Show the row and column of point.
    mode-line-position
    evil-mode-line-tag
    ;; Show the active major and minor modes.
    " "
    mode-line-modes)
  "Composite mode line construct to be shown right-aligned."
  :type 'sexp)

;; Actually reset the mode line format to show all the things we just
;; defined.
(setq-default mode-line-format
              '(:eval (replace-regexp-in-string
                       "%" "%%"
                       (my/mode-line-align
                        (format-mode-line my/mode-line-left)
                        (format-mode-line my/mode-line-right))
                       'fixedcase 'literal)))

(use-package paren
  :hook (prog-mode . show-paren-mode))

(use-package paren-blink
  :straight nil
  :load-path "lisp/")

(use-package paren-face
  :hook
  (lispy-mode . paren-face-mode))

(use-package ace-window
  :bind (("M-o" . ace-window))
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package winner-mode
  :straight nil
  :bind (:map evil-window-map
              ("u" . winner-undo)
              ("U" . winner-redo))
  :config
  (winner-mode))

(dawran/leader-keys "w" 'evil-window-map)

(use-package hl-fill-column
  :hook (prog-mode . hl-fill-column-mode)
  :config
  (set-face-attribute 'hl-fill-column-face nil
                      :background (face-attribute 'shadow :background)
                      :inverse-video nil))

(defun dawran/visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :defer t)

(use-package unicode-fonts
  :defer t
  :config
  (unicode-fonts-setup))

(use-package ns-auto-titlebar
  :hook (after-init . ns-auto-titlebar-mode))

(setq ns-use-proxy-icon nil
      frame-title-format nil)

(use-package rainbow-mode
  :commands rainbow-mode)

(setq enable-recursive-minibuffers t)

;; Package `selectrum' is an incremental completion and narrowing
;; framework. Like Ivy and Helm, which it improves on, Selectrum
;; provides a user interface for choosing from a list of options by
;; typing a query to narrow the list, and then selecting one of the
;; remaining candidates. This offers a significant improvement over
;; the default Emacs interface for candidate selection.
(use-package selectrum
  :straight (:host github :repo "raxod502/selectrum")
  :custom
  (selectrum-count-style 'current/matches)
  :init
  ;; This doesn't actually load Selectrum.
  (selectrum-mode +1)
  (dawran/leader-keys "TAB" #'selectrum-repeat))

;; Package `prescient' is a library for intelligent sorting and
;; filtering in various contexts.
(use-package prescient
  :config
  ;; Remember usage statistics across Emacs sessions.
  (prescient-persist-mode +1)
  ;; The default settings seem a little forgetful to me. Let's try
  ;; this out.
  (setq prescient-history-length 1000))

;; Package `selectrum-prescient' provides intelligent sorting and
;; filtering for candidates in Selectrum menus.
(use-package selectrum-prescient
  :straight (:host github :repo "raxod502/prescient.el"
                   :files ("selectrum-prescient.el"))
  :after selectrum
  :config
  (selectrum-prescient-mode +1))

(use-package marginalia
  :bind (:map minibuffer-local-map
              ("C-M-a" . marginalia-cycle))
  :init
  (marginalia-mode)
  ;; When using Selectrum, ensure that Selectrum is refreshed when cycling annotations.
  (advice-add #'marginalia-cycle :after
              (lambda () (when (bound-and-true-p selectrum-mode) (selectrum-exhibit))))
  (setq marginalia-annotators '(marginalia-annotators-heavy
                                marginalia-annotators-light nil)))

;; Package `ctrlf' provides a replacement for `isearch' that is more
;; similar to the tried-and-true text search interfaces in web
;; browsers and other programs (think of what happens when you type
;; ctrl+F).
(use-package ctrlf
  :straight (:host github :repo "raxod502/ctrlf")
  :bind
  ("s-f" . ctrlf-forward-literal)

  :init

  (ctrlf-mode +1))

(use-package embark
  :bind
  ("C-S-a" . embark-act)

  :config
  ;; For Selectrum users:
  (defun current-candidate+category ()
    (when selectrum-active-p
      (cons (selectrum--get-meta 'category)
            (selectrum-get-current-candidate))))

  (add-hook 'embark-target-finders #'current-candidate+category)

  (defun current-candidates+category ()
    (when selectrum-active-p
      (cons (selectrum--get-meta 'category)
            (selectrum-get-current-candidates
             ;; Pass relative file names for dired.
             minibuffer-completing-file-name))))

  (add-hook 'embark-candidate-collectors #'current-candidates+category)

  ;; No unnecessary computation delay after injection.
  (add-hook 'embark-setup-hook 'selectrum-set-selected-candidate)

  :custom
  (embark-action-indicator
   (lambda (map)
     (which-key--show-keymap "Embark" map nil nil 'no-paging)
     #'which-key--hide-popup-ignore-command)
   embark-become-indicator embark-action-indicator))

(use-package helpful
  :bind (;; Remap standard commands.
         ("C-h f"   . #'helpful-callable)
         ("C-h v"   . #'helpful-variable)
         ("C-h k"   . #'helpful-key)
         ("C-c C-d" . #'helpful-at-point)
         ("C-h C"   . #'helpful-command)
         ("C-h F"   . #'describe-face)))

(use-package recentf
  :defer 1
  :custom
  ;; Increase recent entries list from default (20)
  (recentf-max-saved-items 100)
  :config
  (recentf-mode +1))

(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)
(setq-default indent-tabs-mode nil)

(use-package evil-nerd-commenter
  :bind ("s-/" . evilnc-comment-or-uncomment-lines))

(use-package ws-butler
  :blackout t
  :hook ((text-mode . ws-butler-mode)
         (prog-mode . ws-butler-mode))
  :custom
  ;; ws-butler normally preserves whitespace in the buffer (but strips it from
  ;; the written file). While sometimes convenient, this behavior is not
  ;; intuitive. To the average user it looks like whitespace cleanup is failing,
  ;; which causes folks to redundantly install their own.
  (ws-butler-keep-whitespace-before-point nil))

(use-package lispy
  :blackout t
  :hook ((emacs-lisp-mode . lispy-mode)
         (clojure-mode . lispy-mode)
         (clojurescript-mode . lispy-mode)
         (cider-repl-mode . lispy-mode))
  :custom
  (lispy-close-quotes-at-end-p t)
  :config
  (add-hook 'lispy-mode-hook #'turn-off-smartparens-mode))

(use-package lispyville
  :blackout t
  :hook ((lispy-mode . lispyville-mode))
  :custom
  (lispyville-key-theme '(operators
                          c-w
                          (prettify insert)
                          additional
                          additional-insert
                          additional-movement
                          additional-wrap
                          (atom-movement normal visual)
                          slurp/barf-cp))
  :config
  (lispy-set-key-theme '(lispy c-digits))
  (lispyville-set-key-theme))

(use-package evil-multiedit
  :bind (:map evil-visual-state-map
              ("R" . evil-multiedit-match-all)
              ("M-d" . evil-multiedit-match-and-next)
              ("M-D" . evil-multiedit-match-and-prev)
              ("C-M-d" . evil-multiedit-restore)
              :map evil-normal-state-map
              ("M-d" . evil-multiedit-match-symbol-and-next)
              ("M-D" . evil-multiedit-match-symbol-and-prev)
              ("C-M-d" . evil-multiedit-restore)
              :map evil-insert-state-map
              ("M-d" . evil-multiedit-toggle-marker-here)
              :map evil-motion-state-map
              ("RET" . evil-multiedit-toggle-or-restrict-region)
              :map evil-multiedit-state-map
              ("RET" . evil-multiedit-toggle-or-restrict-region)
              ("C-n" . evil-multiedit-next)
              ("C-p" . evil-multiedit-prev)
              :map evil-multiedit-insert-state-map
              ("C-n" . evil-multiedit-next)
              ("C-p" . evil-multiedit-prev)))

(use-package undo-fu)

(use-package smartparens
  :blackout t
  :hook (prog-mode . smartparens-mode))

(use-package expand-region
  :bind
  ("s-'" .  er/expand-region)
  ("s-\"" .  er/contract-region))

(defun dawran/org-mode-setup ()
  (org-indent-mode)
  (blackout 'org-indent-mode)
  (variable-pitch-mode 1)
  (blackout 'buffer-face-mode)
  (visual-line-mode 1)
  (blackout 'visual-line-mode)
  (dawran/visual-fill))

(use-package org
  :hook (org-mode . dawran/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 2
        org-hide-block-startup nil
        org-src-preserve-indentation nil
        ;; org-startup-folded 'content
        org-cycle-separator-lines 2)

  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp")))

(use-package evil-org
  :blackout t
  :after evil
  :hook (org-mode . evil-org-mode))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun dawran/org-babel-tangle-config ()
  "Automatically tangle our Emacs.org config file when we save it."
  (when (string-equal (buffer-file-name)
                      (expand-file-name "./README.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'dawran/org-babel-tangle-config)))

(use-package org-make-toc
  :hook (org-mode . org-make-toc-mode))

(use-package org-journal
  :commands (org-journal-new-entry org-journal-open-current-journal-file)
  :custom
  (org-journal-date-format "%A, %d/%m/%Y")
  (org-journal-date-prefix "* ")
  (org-journal-file-format "%F.org")
  (org-journal-dir "~/org/journal/")
  (org-journal-file-type 'weekly)
  (org-journal-find-file #'find-file))

(dawran/leader-keys
  "n" '(:ignore t :which-key "notes")
  "nj" '(org-journal-open-current-journal-file :which-key "journal"))

(use-package org-roam
  :commands org-roam-find-file
  :custom
  (org-roam-directory "~/org/roam/")
  :config
  (dawran/leader-keys
    :keymaps 'org-roam-mode-map
    "nl" 'org-roam
    "ng" 'org-roam-graph-show
    :keymaps 'org-mode-map
    "ni" 'org-roam-insert
    "nI" 'org-roam-insert-immediate))

(dawran/leader-keys
  "nf" 'org-roam-find-file)

(use-package org-tree-slide
  :commands (org-tree-slide-mode)
  :custom
  (org-image-actual-width nil)
  (org-tree-slide-slide-in-effect nil)
  (org-tree-slide-activate-message "Presentation started.")
  (org-tree-slide-deactivate-message "Presentation ended.")
  (org-tree-slide-breadcrumbs " > ")
  (org-tree-slide-header t))

(use-package dired
  :straight nil
  :commands (dired)
  :bind ("C-x C-j" . dired-jump)
  :init
  (setq dired-auto-revert-buffer t
        dired-dwim-target t)
  :config
  (setq ls-lisp-dirs-first t
        insert-directory-program "gls"
        dired-listing-switches "-agho --group-directories-first")
  (evil-collection-define-key 'normal 'dired-mode-map
    (kbd "C-c C-e") 'wdired-change-to-wdired-mode))

(dawran/leader-keys
  "d" '(dired-jump :which-key "dired"))

(use-package dired-x
  :after dired
  :straight nil
  :init (setq-default dired-omit-files-p t)
  :config
  (add-to-list 'dired-omit-extensions ".DS_Store"))

(use-package dired-single
  :after dired
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))

(use-package dired-ranger
  :after dired
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "y" 'dired-ranger-copy
    "X" 'dired-ranger-move
    "p" 'dired-ranger-paste))

(setq exec-path (append exec-path '("/usr/local/bin")))

(use-package vterm
  :commands vterm
  :config
  (setq vterm-max-scrollback 10000))

(defun dawran/eshell-history ()
  (interactive)
  (insert (completing-read
           "Eshell history:"
           (cl-remove-duplicates
            (ring-elements eshell-history-ring)
            :test #'equal :from-end t))))

(defun dawran/configure-eshell ()
  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  ;; Use Ivy to provide completions in eshell
  (define-key eshell-mode-map (kbd "<tab>") 'completion-at-point)

  ;; Bind some useful keys for evil-mode
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'dawran/eshell-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-a") 'eshell-bol)

  (setq eshell-history-size          10000
        eshell-buffer-maximum-lines  10000
        eshell-hist-ignoredups           t
        eshell-highlight-prompt          t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell
  :hook (eshell-first-time-mode . dawran/configure-eshell))

(use-package exec-path-from-shell
  :defer 1
  :init
  (setq exec-path-from-shell-check-startup-files nil)
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(with-eval-after-load 'esh-opt
  (setq eshell-destroy-buffer-when-process-dies t))

(dawran/leader-keys
  "e" 'eshell)

(use-package eshell-toggle
  :custom
  (eshell-toggle-use-git-root t)
  (eshell-toggle-run-command nil)
  :bind
  ("C-M-'" . eshell-toggle))

(use-package project
  :commands project-root
  :bind
  (("s-p" . project-find-file)
   ("s-P" . project-switch-project))
  :init
  (defun project-magit-status+ ()
    ""
    (interactive)
    (magit-status (project-root (project-current t))))
  :custom
  (project-switch-commands '((project-find-file "Find file")
                             (project-find-regexp "Find regexp")
                             (project-dired "Dired")
                             (project-magit-status+ "Git" ?g)
                             (project-eshell "Eshell"))))

(use-package magit
  :bind ("s-g" . magit-status)
  :custom
  (magit-diff-refine-hunk 'all)
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(dawran/leader-keys
  "g"   '(:ignore t :which-key "git")
  "gg"  'magit-status
  "gb"  'magit-blame-addition
  "gd"  'magit-diff-unstaged
  "gf"  'magit-file-dispatch
  "gl"  'magit-log-buffer-file)

(use-package rg
  :bind ("s-F" . rg-project)
  :config
  (rg-enable-default-bindings))

(use-package lsp-mode
  :disabled t
  :commands lsp
  :hook ((clojure-mode . lsp)
         (clojurec-mode . lsp)
         (clojurescript-mode . lsp))
  :init
  (setq lsp-keymap-prefix "s-l")
  :config
  (lsp-enable-which-key-integration t)
  ;; add paths to your local installation of project mgmt tools, like lein
  (setenv "PATH" (concat
                  "/usr/local/bin" path-separator
                  (getenv "PATH")))
  (dolist (m '(clojure-mode
               clojurec-mode
               clojurescript-mode
               clojurex-mode))
    (add-to-list 'lsp-language-id-configuration `(,m . "clojure")))
  (setq lsp-clojure-server-command '("bash" "-c" "clojure-lsp") ;; Optional: In case `clojure-lsp` is not in your PATH
        lsp-enable-indentation nil)

  (dawran/localleader-keys
    :keymaps '(clojure-mode-map clojurescript-mode-map)
    "d" 'lsp-find-definition
    "r" 'lsp-find-references))

(use-package eglot
  :hook ((clojure-mode . eglot-ensure)
         (clojurec-mode . eglot-ensure)
         (clojurescript-mode . eglot-ensure))
  :custom
  (eglot-connect-timeout 300)
  :config
  (add-to-list 'eglot-server-programs
               '((clojure-mode clojurescript-mode) . ("bash" "-c" "/usr/local/bin/clojure-lsp"))))

(use-package eldoc
  :defer t
  :blackout t)

(use-package flymake
  :defer t
  :blackout t)

(use-package clojure-mode
  :custom
  (cljr-magic-requires nil)
  :config
  (setq clojure-indent-style 'align-arguments
        clojure-align-forms-automatically t))

(use-package clj-refactor
  :defer t
  :blackout t)

(use-package cider
  :commands cider
  :custom
  (cider-font-lock-dynamically '(macro core function var))
  :config
  (setq cider-repl-display-in-current-window nil
        cider-repl-pop-to-buffer-on-connect nil
        cider-repl-use-pretty-printing t
        cider-repl-buffer-size-limit 100000
        cider-repl-result-prefix ";; => ")
  (add-hook 'cider-repl-mode-hook 'evil-insert-state)
  (dawran/localleader-keys
    :keymaps '(clojure-mode-map clojurescript-mode-map)
    "e" '(:ignore t :which-key "eval")
    "eb" 'cider-eval-buffer
    "ef" 'cider-eval-defun-at-point
    "ee" 'cider-eval-last-sexp
    "t" '(:ignore t :which-key "test")
    "tt" 'cider-test-run-test
    "tn" 'cider-test-run-ns-tests))

(dawran/localleader-keys
  :keymaps '(clojure-mode-map clojurescript-mode-map)
  "," 'cider)

(use-package clj-refactor
  :hook (clojure-mode . clj-refactor-mode))

(use-package markdown-mode
  :mode "\\.md\\'"
  :hook (markdown-mode . dawran/visual-fill)
  :config
  (setq markdown-command "marked"))

(use-package flycheck
  :hook (lsp-mode . flycheck-mode))

(use-package flyspell
  :blackout t
  :straight nil
  :hook
  (prog-mode . flyspell-prog-mode)
  (text-mode . flyspell-mode))

(use-package eldoc
  :blackout t)

(use-package extras
  :straight nil
  :load-path "lisp/"
  :bind
  (("M-y" . yank-pop+)
   ("C-x C-r" . recentf-open-files+)))

(setq world-clock-list '(("Asia/Taipei" "Taipei")
                         ("America/Toronto" "Toronto")
                         ("America/Los_Angeles" "San Francisco")
                         ("Europe/Berlin" "Düsseldorf")
                         ("Europe/London" "GMT")))

(dawran/leader-keys
  "tc" 'world-clock)

(use-package elfeed
  :commands elfeed
  :custom
  (elfeed-feeds '("https://planet.emacslife.com/atom.xml"
                  "http://planet.clojure.in/atom.xml"))
  :config
  (dawran/leader-keys
    "R" '(elfeed :which-key "RSS")))
