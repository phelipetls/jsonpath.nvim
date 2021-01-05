vim.api.nvim_command [[packadd! nvim-treesitter]]

require "nvim-treesitter.configs".setup {
  highlight = {
    enable = true,
  }
}

vim.api.nvim_command [[hi link TSConstructor Normal]]
