vim.api.nvim_command([[packadd! nvim-treesitter]])
vim.api.nvim_command([[packadd! nvim-ts-context-commentstring]])
vim.api.nvim_command([[packadd! nvim-ts-autotag]])

require("nvim-treesitter.configs").setup({
  ensure_installed = { "typescript", "javascript", "tsx", "toml", "jsonc", "python", "yaml", "jsdoc" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
})

vim.api.nvim_command([[hi link TSConstructor Function]])
