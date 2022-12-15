vim.keymap.set("n", "<space>ss", function()
  vim.cmd.source(vim.api.nvim_buf_get_name(0))
  vim.cmd.PackerCompile()
end, {
  buffer = true,
  desc = "Reload plugins.lua and run Packer compile",
})

require("impatient")

vim.cmd("packadd! cfilter")

-- prevent loading netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return require("packer").startup(function(use)
  -- optimization
  use("vim-scripts/LargeFile")
  use("lewis6991/impatient.nvim")

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

  use({
    "tpope/vim-abolish",
    config = function()
      vim.cmd.Abolish("taebl table")
      vim.cmd.Abolish("paramater parameter")
      vim.cmd.Abolish("consoel console")
      vim.cmd.Abolish("lenght length")
      vim.cmd.Abolish("improt import")
      vim.cmd.Abolish("obejct object")
      vim.cmd.Abolish("entires entries")
      vim.cmd.Abolish("cosnt const")
      vim.cmd.Abolish("docuemnt document")
      vim.cmd.Abolish("funciton function")
    end,
  })

  use("tommcdo/vim-lion")
  use("tpope/vim-sleuth")
  use("andymass/vim-matchup")

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
    "https://gitlab.com/yorickpeterse/nvim-pqf",
    config = function()
      require("pqf").setup()
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

  -- debugging
  use({
    "andrewferrier/debugprint.nvim",
    config = function()
      require("debugprint").setup({
        create_keymaps = false,
      })
    end,
  })
end)
