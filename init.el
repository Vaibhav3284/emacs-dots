;;; --- Speed Optimization ---
;; Raise garbage collection threshold during startup
(setq gc-cons-threshold 100000000)
;; Restore it after startup to keep memory usage sane
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold 800000)))

;;; --- Package Manager Setup (Straight.el) ---
;; This allows us to install themes directly from GitHub
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-get-el
       (expand-file-name "straight/repos/straight.el/bootstrap-get.el" user-emacs-directory)))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install use-package to work with straight
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;;; --- UI / Minimalist Settings ---
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(set-fringe-mode 10)
(display-line-numbers-mode 1)

;;; --- Theme (4chan-emacs-themes) ---
(straight-use-package
 '(four-chan-themes :type git :host github :repo "Senka07/4chan-emacs-themes"))

;; Add the theme's folder to the custom-theme-load-path
(add-to-list 'custom-theme-load-path 
             (expand-file-name "straight/repos/four-chan-themes/" user-emacs-directory))

;; Load the theme using the correct filename prefix
(load-theme 'tomorrow-4chan-night t)

;;; --- Autocomplete (Company Mode) ---
(use-package company
  :defer t
  :init (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 1
        company-tooltip-align-annotations t))

;;; --- Fast Search/Completion in Minibuffer (Vertico) ---
;; Highly recommended for a "fast" feel
(use-package vertico
  :init
  (vertico-mode))

;;; --- Essential Performance Tweaks ---
(setq-default cursor-type 'bar)
(setq-default indent-tabs-mode nil)
(setq make-backup-files nil) ; Stop creating *~ backup files
(setq auto-save-default nil) ; Stop creating #autosave# files

(provide 'init)
