vim.api.nvim_command([[hi link TSConstructor Function]])

vim.treesitter.language.register('css', { 'scss' })
vim.treesitter.language.register('markdown', { 'mdx' })

local treesitter_augroup = vim.api.nvim_create_augroup("TreesitterAugroup", { clear = true })

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = treesitter_augroup,
  pattern = { "javascript", "lua", "typescript", "typescriptreact", "javascriptreact", "json", "yaml", "astro" },
  callback = function()
    vim.wo.foldenable = true
    vim.wo.foldlevel = 99
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
  end,
})

require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    disable = function(_, bufnr)
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
      "html",
      "htmlhugo",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "jsx",
      "markdown",
    },
  },
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["a`"] = "@templatestring.outer",
        ["i`"] = "@templatestring.inner",
        ["aC"] = "@codeblock.outer",
        ["iC"] = "@codeblock.inner",
        -- ["at"] = "@tag.outer",
        -- ["it"] = "@tag.inner",
      },
      -- You can choose the select mode (default is charwise 'v')
      selection_modes = {
        ["@parameter.outer"] = "v", -- charwise
        ["@function.outer"] = "V", -- linewise
        ["@class.outer"] = "<c-v>", -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding xor succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      include_surrounding_whitespace = false,
    },
    swap = {
      enable = true,
      swap_next = {
        ["],"] = "@parameter.inner",
      },
      swap_previous = {
        ["[,"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]]"] = "@function.outer",
      },
      goto_next_end = {
        ["]["] = "@function.outer",
      },
      goto_previous_start = {
        ["[["] = "@function.outer",
      },
      goto_previous_end = {
        ["[]"] = "@function.outer",
      },
    },
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
  matchup = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<BS>",
      node_incremental = "[<BS>",
      node_decremental = "]<BS>",
    }
  }
})
