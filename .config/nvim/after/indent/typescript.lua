-- fix dumb change in vim upstream that makes formatexpr takes precedent over
-- formatprg. see https://github.com/neovim/neovim/issues/13113
vim.bo.formatexpr = ''
