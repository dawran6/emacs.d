;;; sketch-white-theme.el --- Theme Sketch

;; Copyright (C) 2020 Daw-Ran Liou

;; Author: Daw-Ran Liou
;; Version: 0.1
;; Package-Requires: ((emacs "24"))
;; Created with ThemeCreator, https://github.com/mswift42/themecreator.


;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;; This file is not part of Emacs.

;;; Commentary:

;;; Code:

(deftheme sketch-white)
(let ((class '((class color) (min-colors 89)))
      (fg "#111111")
      (bg "#ffffff")
      (weak "#888888")
      (weaker "#dddddd")
      (weakest "#efefef")
      (highlight "#fda50f")
      ;; (str     "#0271b5") ; blue
      (str     "#3c5e2b") ; green
      (success "#00ff00")
      (warning "#ff0000")
      )
  (custom-theme-set-faces
   'sketch-white

   ;; default
   `(default ((,class (:background ,bg :foreground ,fg))))
   `(fringe ((,class (:background ,bg))))
   `(highlight ((,class (:foreground ,fg :background ,highlight))))
   `(region ((,class (:foreground ,fg :background ,highlight))))
   `(show-paren-match ((,class (:background ,bg :foreground ,success :bold t))))
   `(show-paren-mismatch ((,class (:background ,bg :foreground ,warning :bold t))))
   `(minibuffer-prompt ((,class (:bold t :foreground ,fg))))
   `(isearch ((,class (:bold t :foreground ,fg :background ,weak :bold t))))
   `(lazy-highlight ((,class (:foreground ,fg :background ,weaker))))
   `(link ((,class (:underline t))))
   `(parenthesis ((,class (:background ,bg :foreground ,weak))))
   `(trailing-whitespace ((,class :foreground nil :background ,warning)))
   `(cursor ((,class (:background ,fg :foreground ,bg))))
   `(vertical-border ((,class (:foreground ,weaker))))
   `(default-italic ((,class (:italic t))))

   ;; mode line
   `(mode-line ((,class (:foreground ,fg :background ,weakest :height 0.9))))
   `(mode-line-inactive ((,class (:foreground ,weaker :background ,bg :height 0.9))))

   ;; font lock
   `(font-lock-builtin-face ((,class (:foreground ,fg))))
   `(font-lock-comment-face ((,class (:inherit font-lock-string-face))))
   `(font-lock-negation-char-face ((,class (:foreground ,fg))))
   `(font-lock-reference-face ((,class (:foreground ,fg))))
   `(font-lock-constant-face ((,class (:foreground ,fg))))
   `(font-lock-doc-face ((,class (:inherit font-lock-comment-face))))
   `(font-lock-function-name-face ((,class (:foreground ,fg))))
   `(font-lock-keyword-face ((,class (:foreground ,fg))))
   `(font-lock-string-face ((,class (:foreground ,weak))))
   `(font-lock-type-face ((,class (:foreground ,fg))))
   `(font-lock-variable-name-face ((,class (:foreground ,fg))))
   `(font-lock-warning-face ((,class (:foreground ,fg :underline (:color ,warning :style wave)))))
   `(hl-fill-column-face ((,class (:background ,weakest))))
   `(fill-column-indicator ((,class (:foreground ,weakest))))

   ;; hl line
   `(hl-line ((,class (:background ,weakest))))

   ;; company
   `(company-tooltip ((,class (:foreground ,fg :background ,weakest))))
   `(company-tooltip-selection ((,class (:background ,weaker :foreground ,fg))))
   `(company-tooltop-annotation ((,class (:foreground ,fg))))
   `(company-tooltip-common ((,class (:foreground ,fg :bold t))))
   `(company-tooltip-common-selection ((,class (:foreground ,fg :bold t))))
   `(company-scrollbar-bg ((,class (:background ,weaker))))
   `(company-scrollbar-fg ((,class (:background ,weak))))

   ;; git gutter
   `(git-gutter:modified ((,class (:background ,highlight :foreground ,highlight))))
   `(git-gutter:added ((,class (:background ,success :foreground ,success))))
   `(git-gutter:deleted ((,class (:background ,warning :foreground ,warning))))

   ))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'sketch-white)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; sketch-white-theme.el ends here
