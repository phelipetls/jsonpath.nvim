vim.api.nvim_command([[packadd! nvim-treesitter]])
vim.api.nvim_command([[packadd! nvim-ts-context-commentstring]])
vim.api.nvim_command([[packadd! nvim-ts-autotag]])
vim.api.nvim_command([[packadd! nvim-ts-rainbow]])
vim.api.nvim_command([[packadd! playground]])

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "typescript",
    "javascript",
    "tsx",
    "toml",
    "jsonc",
    "python",
    "yaml",
    "jsdoc",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    disable = { 'yaml' }
  },
  context_commentstring = {
    enable = true,
  },
  autotag = {
    enable = true,
    filetypes = {
      'html',
      'htmlhugo',
      'javascript',
      'typescript',
      'javascriptreact',
      'typescriptreact',
      'svelte',
      'vue',
      'tsx',
      'jsx',
      'markdown',
    },
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
})

vim.api.nvim_command([[hi link rainbowcol1 User2]])
vim.api.nvim_command([[hi link rainbowcol2 User3]])
vim.api.nvim_command([[hi link rainbowcol3 User4]])
vim.api.nvim_command([[hi link rainbowcol4 User5]])
vim.api.nvim_command([[hi link rainbowcol5 User6]])
vim.api.nvim_command([[hi link rainbowcol6 User7]])
vim.api.nvim_command([[hi link rainbowcol7 User8]])
