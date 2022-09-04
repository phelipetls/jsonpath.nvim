vim.api.nvim_command([[packadd! nvim-treesitter]])
vim.api.nvim_command([[packadd! nvim-ts-context-commentstring]])
vim.api.nvim_command([[packadd! nvim-ts-autotag]])
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
    "css",
  },
  highlight = {
    enable = true,
    disable = function(lang, bufnr)
      if vim.fn.bufname(bufnr):match(".min.js$") then
        return true
      end

      return false
    end,
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
})

vim.api.nvim_command([[hi link TSConstructor Function]])
