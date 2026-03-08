;; This buffer is for text that is not saved, and for Lisp evaluation.
;; To create a file, visit it with ‘C-x C-f’ and enter text in its buffer.;; --- 1. CORE UI (Minimalism) ---
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(set-fringe-mode 10)
(setq visible-bell t)

(column-number-mode)
(global-display-line-numbers-mode t)
;; Note: Ensure "Fira Code" is installed on your system!
(set-face-attribute 'default nil :font "Fira Code" :height 100)

;; --- 2. PACKAGE SETUP (The Stable Way) ---
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; --- 3. LOOK & FEEL ---

(add-to-list 'custom-theme-load-path
             "~/.emacs.d/emacs-boron-theme")
(load-theme 'boron t)


(use-package doom-modeline
  :init (doom-modeline-mode 1))

(use-package all-the-icons)

;; --- 4. COMPLETION (Vertico Stack) ---
(use-package vertico :init (vertico-mode))
(use-package marginalia :init (marginalia-mode))
(use-package orderless
  :custom (completion-styles '(orderless basic)))

;; --- 5. LSP (Coding Features) ---
(use-package lsp-mode
  :hook ((python-mode . lsp)
         (lsp-mode . lsp-enable-symbol-highlight))
  :custom (lsp-headerline-breadcrumb-enable nil))

(use-package lsp-ui :commands lsp-ui-mode)

(use-package company
  :hook (prog-mode . company-mode)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

;; --- 6. PDF VIEWER (pdf-tools) ---
(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-page)
  (setq pdf-view-continuous t)
  (setq pdf-view-use-scaling t)
  :hook (pdf-view-mode . (lambda () (cursor-mode -1))))

;; --- 7. VTERM & PROJECTILE ---
(use-package vterm)

(use-package projectile
  :init
  (projectile-mode +1)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :config
  (setq projectile-project-search-path '("~/projects" "~/dev")))

;; --- 8. WINDOW MANAGEMENT & SCROLLING ---
(winner-mode 1) ;; C-c <left> to undo window layout
(setq compilation-scroll-output t)

(set-window-fringes nil 0 0)
(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(window-divider-mode 1)

;; Smooth Scrolling
(if (fboundp 'pixel-scroll-precision-mode)
    (progn
      (pixel-scroll-precision-mode 1)
      (setq pixel-scroll-precision-interpolation-total-time 0.1)))

;; --- 9. PERSISTENCE (Restore session) ---
(save-place-mode 1)
(recentf-mode 1)
(setq recentf-max-saved-items 25)

(setq desktop-path '("~/.emacs.d/")
      desktop-dirname "~/.emacs.d/"
      desktop-base-file-name "emacs-desktop"
      desktop-save t
      desktop-load-locked-desktop t)
(desktop-save-mode 1)

;; Backup and Autosave cleanup
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms `((".*" "~/.emacs.d/auto-save-list/" t)))

;; Clean up the auto-generated custom-set-variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
