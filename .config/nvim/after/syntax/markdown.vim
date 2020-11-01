hi link markdownCode String
hi link markdownCodeBlock Special
hi link markdownHeadingDelimiter Constant
hi link markdownH1 Function
hi link markdownH2 markdownH1
hi link markdownH3 markdownH1
hi link markdownH4 markdownH1
hi link markdownH5 markdownH1
hi link markdownH6 markdownH1

syntax region latexDisplayEquation start=/\\\\\[/ end=/\\\\\]/ keepend
syntax region latexDisplayEquationDollars start=/\$\$/ end=/\$\$/ keepend
syntax region latexInlineEquation start=/\\\\(/ end=/\\\\)/ keepend

hi link latexDisplayEquation PreProc
hi link latexDisplayEquationDollars PreProc
hi link latexInlineEquation PreProc
