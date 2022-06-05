vim.api.nvim_command [[packadd! nvim-treesitter]]

require "nvim-treesitter.configs".setup {
  ensure_installed = {"typescript", "javascript", "tsx", "json"},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  }
}

vim.api.nvim_command [[hi link TSConstructor Function]]
