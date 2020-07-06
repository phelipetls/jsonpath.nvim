hi link htmlTag Ignore
hi link htmlEndTag Ignore

syn match htmlCustomArg /[A-z-]\+/ contained containedin=htmlTag
hi link htmlCustomArg htmlArg

syn keyword htmlTagName summary
