vim.api.nvim_command [[packadd! nvim-treesitter]]

require "nvim-treesitter.configs".setup {
  ensure_installed = {"typescript", "javascript", "tsx", "json"},
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  }
}

vim.api.nvim_command [[hi link TSConstructor Function]]
