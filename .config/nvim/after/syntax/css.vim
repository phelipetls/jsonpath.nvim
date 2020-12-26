hi link cssBraces Normal
hi link cssBraceError Normal
hi link cssImportant Identifier

syn match cssMultiRowProp contained "\<row-\(count\|fill\|gap\|rule\(-\(color\|style\|width\)\)\=\|span\|width\)\>"
hi link cssMultiRowProp cssMultiColumnProp

syn keyword cssGap gap
hi link cssGap cssProp
