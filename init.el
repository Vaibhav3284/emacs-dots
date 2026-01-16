;; --- 1. CORE UI (Minimalism) ---
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(set-fringe-mode 10)
(setq visible-bell t)

(column-number-mode)
(global-display-line-numbers-mode t)
(set-face-attribute 'default nil :font "Fira Code" :height 100)

;; --- 2. PACKAGE SETUP (The Stable Way) ---
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Install use-package if it's not there
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; --- 3. LOOK & FEEL ---
(use-package doom-themes
  :config (load-theme 'doom-one t))

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
         (rust-mode . lsp))
  :custom (lsp-headerline-breadcrumb-enable nil))

(use-package lsp-ui :commands lsp-ui-mode)

(use-package company
  :hook (lsp-mode . company-mode)
  :custom (company-idle-delay 0.0))
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

;; --- 6. PDF VIEWER (pdf-tools) ---
(use-package pdf-tools
  :ensure t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config
  (pdf-tools-install)          ; This builds the server-side tool automatically
  (setq-default pdf-view-display-size 'fit-page)

  ;; --- SMOOTH SCROLLING ---
  (setq pdf-view-continuous t) ; Next page starts immediately after current
                                
  (add-hook 'pdf-view-mode-hook (lambda () (cursor-mode -1)))) ; Enable dark mode))) ; Hide cursor in PDFs


;; --- 7. RUST AUTOCOMPLETE (LSP + Rust-analyzer) ---
(use-package rustic
  :ensure t
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  ;; uncomment for less rebuilds
  ;; (setq rustic-format-on-save t)
  (setq lsp-eldoc-render-all t)
  (setq lsp-rust-analyzer-completion-add-call-parenthesis t))

;; Ensure company-mode starts with lsp
(use-package company
  :ensure t
  :hook (prog-mode . company-mode)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

;; Better scrolling for high-refresh monitors
(setq pixel-scroll-precision-mode t)

;; Fix PDF rendering quality on high-DPI screens
(setq pdf-view-use-scaling t
      pdf-view-use-imagemagick t)

;; --- 8. VTERM (Better Terminal) ---
(use-package vterm
  :ensure t)

;; --- 9. SMART COMPILATION & EXECUTION ---
(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :config
  (setq projectile-project-search-path '("~/projects" "~/dev"))) ; Change to your dev folders

;; --- 10. RUST KEYBINDINGS (One-Key Run) ---
(defun my-rust-run ()
  "Run the current rust project using cargo."
  (interactive)
  (compile "cargo run"))

(defun my-rust-test ()
  "Test the current rust project using cargo."
  (interactive)
  (compile "cargo test"))

(add-hook 'rust-mode-hook
          (lambda ()
            (local-set-key (kbd "<f5>") 'my-rust-run)
            (local-set-key (kbd "<f6>") 'rustic-cargo-check)
            (local-set-key (kbd "<f7>") 'my-rust-test)))

;; Make the compilation window scroll automatically to the bottom
(setq compilation-scroll-output t)


(set-window-fringes nil 0 0)
(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(window-divider-mode 1)

(winner-mode 1)
;; Press 'C-c <left>' to undo a window split/change
;; Press 'C-c <right>' to redo it


;; --- 11. PERSISTENCE (Restore session) ---

;; Remember cursor position in files
(save-place-mode 1)

;; Save and restore open buffers/files
(setq desktop-save-mode 1)
(setq desktop-path '("~/.emacs.d/"))
(setq desktop-dirname "~/.emacs.d/")
(setq desktop-base-file-name "emacs-desktop")

;; Don't ask if I want to save the desktop, just do it
(setq desktop-save t)

;; Clean up the "Found a desktop file" warning on startup
(setq desktop-load-locked-desktop t)

;; Restore the desktop on startup
(desktop-save-mode 1)

;; Remember recently opened files (accessible via M-x counsel-recentf or C-c p r)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)

(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms `((".*" "~/.emacs.d/auto-save-list/" t)))

;; --- SMOOTH PIXEL SCROLLING ---
(if (fboundp 'pixel-scroll-precision-mode)
    (pixel-scroll-precision-mode 1))

;; Fine-tune the scroll speed
(setq pixel-scroll-precision-interpolation-total-time 0.1)
