vim.cmd("inoreabbrev <buffer> {{ {{<space><space>}}<left><left><left><C-R>=utils#eatchar('\\s')<CR>")

vim.bo.omnifunc = "syntaxcomplete#Complete"
