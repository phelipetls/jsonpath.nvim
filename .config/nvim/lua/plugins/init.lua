local packer_augroup = vim.api.nvim_create_augroup('PackerAutocmds', { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = packer_augroup,
  pattern = "*/lua/plugins/init.lua",
  callback = function()
    local file_name = vim.fn.expand("<afile>")
    vim.cmd.source(file_name)
    vim.cmd.PackerCompile()
  end,
})

vim.cmd("packadd! cfilter")

-- prevent loading netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return require("packer").startup(function(use)
  -- optimization
  use("vim-scripts/LargeFile")

  -- misc
  use("nvim-lua/plenary.nvim")

  -- colorscheme
  use({
    "bluz71/vim-moonfly-colors",
    config = function()
      vim.g.moonflyWinSeparator = 2
      vim.cmd.colorscheme("moonfly")
    end,
  })

  -- text editing
  use("tpope/vim-surround")
  use("tpope/vim-commentary")
  use("tpope/vim-repeat")
  use("tpope/vim-unimpaired")
  use("tpope/vim-speeddating")
  use("tpope/vim-abolish")
  use("tommcdo/vim-lion")
  use("tpope/vim-sleuth")

  use({
    "AndrewRadev/inline_edit.vim",
    config = function()
      vim.keymap.set("n", "<C-c>", "<cmd>InlineEdit<CR>")
      vim.g.inline_edit_autowrite = 1
    end,
  })

  use({
    "Wansmer/treesj",
    config = function()
      vim.keymap.set("n", "gJ", "<cmd>TSJJoin<CR>")
      vim.keymap.set("n", "gS", "<cmd>TSJSplit<CR>")

      require("treesj").setup({
        use_default_keymaps = false,
      })
    end,
  })

  use({
    "editorconfig/editorconfig-vim",
    config = function()
      vim.g.EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*" }
    end,
  })

  -- git
  use("tpope/vim-fugitive")
  use("tpope/vim-rhubarb")
  use("shumphrey/fugitive-gitlab.vim")
  use("tommcdo/vim-fugitive-blame-ext")

  -- file navigation
  use({
    "justinmk/vim-dirvish",
    config = function()
      vim.g.dirvish_mode = [[:sort ,^.*[\/],]]
    end,
  })

  use({
    "ibhagwan/fzf-lua",
    config = function()
      require("plugins.config.fzf_lua")
    end,
  })

  -- lsp
  use({
    "neoclide/coc.nvim",
    branch = "release",
    run = "yarn install --frozen-lockfile",
    config = function()
      require("plugins.config.coc")
    end,
  })

  -- incremental search/substitute highlighting
  use({
    "markonm/traces.vim",
    config = function()
      vim.g.traces_abolish_integration = 1
    end,
  })

  -- session management
  use({
    "tpope/vim-obsession",
    config = function()
      vim.g.obsession_no_bufenter = 1
    end,
  })

  -- repl
  use({
    "jpalardy/vim-slime",
    config = function()
      require("plugins.config.slime")
    end,
  })

  -- json
  use({
    "phelipetls/vim-jqplay",
    config = function()
      vim.g.jqplay = {
        mods = "vertical",
      }
    end,
  })
  use({ "phelipetls/jsonpath.nvim", requires = "phelipetls/nvim-treesitter" })

  -- web development with hugo
  use("phelipetls/vim-hugo")

  -- appearance
  use({
    "nvim-lualine/lualine.nvim",
    config = function()
      require("plugins.config.lualine")
    end,
  })

  use({
    "lukas-reineke/headlines.nvim",
    config = function()
      require("headlines").setup({
        mdx = vim.tbl_deep_extend("force", require("headlines").config.markdown, {
          treesitter_language = "markdown",
        }),
      })
    end,
  })

  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      vim.g.indent_blankline_filetype_exclude = { "help", "fugitive", "markdown", "mdx" }

      require("indent_blankline").setup({
        show_end_of_line = true,
      })
    end,
  })

  -- treesitter
  use({
    "phelipetls/nvim-treesitter",
    run = "<cmd>TSUpdate",
    config = function()
      require("plugins.config.treesitter")
    end,
  })
  use("JoosepAlviste/nvim-ts-context-commentstring")
  use("windwp/nvim-ts-autotag")
  use("nvim-treesitter/nvim-treesitter-textobjects")
  use("nvim-treesitter/playground")
end)
