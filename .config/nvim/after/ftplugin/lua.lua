vim.opt_local.makeprg = 'luacheck --no-color'
vim.opt_local.errorformat:append({ '%-G%.%#' })

vim.opt_local.formatprg = 'stylua --search-parent-directories -'
