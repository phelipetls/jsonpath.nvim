hi link typescriptBraces Ignore
hi link typescriptParens Ignore

hi link jsxPunct Ignore
hi link jsxCloseString Ignore
hi link jsxTagName Statement

hi link typescriptEndColons Ignore

syntax match typescriptFuncCall /\<\K\k*\ze\s*(/
syntax match jsDot /\./ skipwhite skipempty nextgroup=typescriptFuncCall

hi link typescriptFuncCall Function

syntax cluster htmlPreProc add=jsxExpressionBlock
syn cluster typescriptExpression add=typescriptOpSymbols,typescriptLogicSymbols
