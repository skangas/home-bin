#!/bin/bash

## This file is NOT part of GNU Emacs.

## GNU Emacs is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.

## GNU Emacs is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You should have received a copy of the GNU General Public License
## along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

# Minimum length of symbols
MINLENGTH=6

# Ignored symbols
IGNORED=(
    "Buffer-menu-sort-by-column"
    "FOO-unload-hook" # example
    "advice-bottom"
    "align-CATEGORY-modes" # example
    "array-element"
    "artist-fc-get-MEMBER-from-symbol" # example
    "artist-go-get-MEMBER-from-symbol" # example
    "auto-resize-tool-bars"
    "compose-chars-after-function"
    "do-forever"
    "etch-a-sketch"
    "ffap-noselect" # proposed name
    "fff-find-loaded-emacs-lisp-function" # old name
    "foldout-enter-subtree"
    "foo-archive" # example
    "command-error-default-function" # built-in
    "delete-after-apply" # proposed name
    "default-next-file" # proposed name
    "foo-close" # example
    "foo-domain" # example
    "foo-host" # example
    "foo-localname" # example
    "foo-open" # example
    "foo-speedbar-menu-items" # example
    "find-source-lisp-file" # old name
    "global-whitespace-mode-hook"
    "htmlfontify-tar-file"
    "immutable-let"
    "helm-descbinds" # third-party
    "image-dired-display-thumbs-ring" # todo
    "j-console-cmd" # third-party
    "indent-flat"
    "inferior-tcl-mode-hook"
    "libgr-progs"
    "mh-show-foo" # example
    "prop-match-value" # struct accessor
    "tempo-template-foo" # example
    "looking-at-backward"
    "m-g-d-t" # abbreviation
    "make-package-desc"
    "map-size"
    "message-setup-very-last-hook"
    "new-font-name" # postscript variable
    "newsticker-download-method"
    "non-retained"
    "number-or-string"
    "ocaml-mode"
    "old-font-name"
    "open-dribble-file"
    "org-export-filter-TYPE-functions"
    "proced-restart-pid"
    "prolog-insert-spaces-after-paren"
    "prolog-tokenize"
    "ps-non-bold-faces"
    "ps-non-italic-faces"
    "query-dns-cached" # old name
    "remove-window-parameters"
    "reverse-ordered-alist"
    "rst-compile-html-preview"
    "rst-over-and-under-default-indent"
    "shell-dynamic-complete-process-environment-variable" # proposed name
    "shift-always"
    "shift-default"
    "smie-align" # proposed name
    "snap-height"
    "so-long--enabled"
    "so-long-minor-mode-hook"
    "start-getting-file-attributes" # proposed name
    "strokes-click-command"
    "strokes-local-set-stroke"
    "strokes-read-stroke-hook"
    "sudo-call-process"
    "true-color"
    "unordered-or"
    "vhdl-additional-empty-lines"
    "visible-whitespace-mappings"
    "w32-downcase-file-names"
    "when-mapped"
)


find_matches() {
    while read symbol; do
        if [[ ! " ${IGNORED[@]} " =~ ${symbol} ]]; then
            matches=$(find . -type f \( -name \*.el \) -exec grep -i -h -e "$symbol" \{\} + | wc -l)
            # found likely typo
            if [ "$matches" = 1 ]; then
                echo "$symbol"
            fi
        fi
    done
}

# `symbols' in .el files
find . -path "./lisp/obsolete" -prune -o \
     -type f \( -name \*.el \) \
     -exec grep -i -h -e "\`[^']\+'" \{\} + |
    sed -nEe "s/[^\`]*\`([A-Za-z0-9-]{${MINLENGTH},})'[^\`]*/\1\n/gp" |
    sort |
    uniq |
    grep -E '^[^-`][A-Za-z0-9/-]+$' |
    grep '-' |
    find_matches
