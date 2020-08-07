(load-theme 'leuven t)

(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)
(recentf-mode 1)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (markdown-mode company elpy dumb-jump use-package flycheck jbeans-theme ess evil-surround toc-org ox-gfm evil-commentary evil)))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro" :foundry "SRC" :slant normal :weight normal :height 90 :width normal)))))

(require 'evil)
(evil-mode 1)
(evil-commentary-mode)
(use-package evil-surround
             :ensure t
             :config
             (global-evil-surround-mode 1))

(define-key global-map (kbd "C-h") #'evil-window-left)
(define-key global-map (kbd "C-j") #'evil-window-down)
(define-key global-map (kbd "C-k") #'evil-window-up)
(define-key global-map (kbd "C-l") #'evil-window-right)

(defface org-block-background
         '((t (:background "#242424")))
         "Face used for the source block background.")

(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

(org-babel-do-load-languages
  'org-babel-load-languages
  '((python . t) (R . t)))

(setq org-babel-python-command "/usr/bin/python3")

(add-to-list 'load-path "~/.emacs.d/elpa/ess-20200103.915")
(setq org-babel-R-command "/usr/bin/R")

(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
(add-hook 'org-mode-hook 'org-display-inline-images)

(setq org-confirm-babel-evaluate nil)

(require 'ox-md nil t)

(eval-after-load "org"
                 '(require 'ox-gfm nil t))

(add-to-list 'org-structure-template-alist
             '("p" "#+BEGIN_SRC python :session :exports both\n\n#+END_SRC"))

(add-to-list 'org-structure-template-alist
             '("r" "#+BEGIN_SRC R :session :exports both\n\n#+END_SRC"))

(require 'toc-org nil t)
(add-hook 'org-mode-hook 'toc-org-mode)

(setq org-src-preserve-indentation nil
      org-edit-src-content-indentation 0)

(setq org-src-fontify-natively t)
