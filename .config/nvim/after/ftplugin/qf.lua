vim.g.qf_disable_statusline = 1
vim.wo.statusline = " %q%{exists('w:quickfix_title')? ' '.w:quickfix_title : ''}%= [%l/%L] "
