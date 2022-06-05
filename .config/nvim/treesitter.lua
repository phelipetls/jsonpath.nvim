vim.api.nvim_command [[packadd! nvim-treesitter]]
vim.api.nvim_command [[packadd! nvim-ts-context-commentstring]]

require "nvim-treesitter.configs".setup {
  ensure_installed = {"typescript", "javascript", "tsx", "json"},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
  context_commentstring = {
    enable = true
  },
}

vim.api.nvim_command [[hi link TSConstructor Function]]
