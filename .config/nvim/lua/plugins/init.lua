require("impatient")

-- prevent loading netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd("packadd! cfilter")

-- optimization
vim.cmd("packadd! LargeFile")
vim.cmd("packadd! impatient.nvim")

-- misc
vim.cmd("packadd! plenary.nvim")

-- colorscheme
vim.cmd("packadd! vim-moonfly-colors")
vim.g.moonflyWinSeparator = 2
vim.cmd.colorscheme("moonfly")

-- text editing
vim.cmd("packadd! vim-surround")
vim.cmd("packadd! vim-commentary")
vim.cmd("packadd! vim-repeat")
vim.cmd("packadd! vim-unimpaired")
vim.cmd("packadd! vim-speeddating")

vim.cmd("packadd! vim-abolish")

vim.cmd("packadd! vim-lion")
vim.cmd("packadd! vim-sleuth")
vim.cmd("packadd! vim-matchup")

vim.cmd("packadd! inline_edit.vim")
vim.keymap.set("n", "<C-c>", "<cmd>InlineEdit<CR>")
vim.g.inline_edit_autowrite = 1

vim.cmd("packadd! treesj")
vim.keymap.set("n", "gJ", "<cmd>TSJJoin<CR>")
vim.keymap.set("n", "gS", "<cmd>TSJSplit<CR>")
require("treesj").setup({
  use_default_keymaps = false,
})

vim.cmd("packadd! editorconfig-vim")
vim.g.EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*" }

-- git
vim.cmd("packadd! vim-fugitive")
vim.cmd("packadd! vim-rhubarb")
vim.cmd("packadd! fugitive-gitlab.vim")
vim.cmd("packadd! vim-fugitive-blame-ext")

-- file navigation
vim.cmd("packadd! vim-dirvish")
vim.g.dirvish_mode = [[:sort ,^.*[\/],]]

vim.cmd("packadd! fzf-lua")
require("plugins.config.fzf_lua")

-- lsp
vim.cmd("packadd! coc.nvim")
require("plugins.config.coc")

-- incremental search/substitute highlighting
vim.cmd("packadd traces.vim")
vim.g.traces_abolish_integration = 1

-- session management
vim.cmd("packadd! vim-obsession")
vim.g.obsession_no_bufenter = 1

-- repl
vim.cmd("packadd! vim-slime")
require("plugins.config.slime")

-- json
vim.cmd("packadd! vim-jqplay")
vim.g.jqplay = {
  mods = "vertical",
}

vim.cmd("packadd! jsonpath.nvim")

-- web development with hugo
vim.cmd("packadd! vim-hugo")

-- appearance
vim.cmd("packadd! lualine.nvim")
require("plugins.config.lualine")

vim.cmd("packadd! nvim-pqf")
require("pqf").setup()

vim.cmd("packadd! headlines.nvim")
require("headlines").setup({
  mdx = vim.tbl_deep_extend("force", require("headlines").config.markdown, {
    treesitter_language = "markdown",
  }),
})

-- treesitter
vim.cmd("packadd! nvim-treesitter")
require("plugins.config.treesitter")

vim.cmd("packadd! nvim-ts-context-commentstring")
vim.cmd("packadd! nvim-ts-autotag")
vim.cmd("packadd! nvim-treesitter-textobjects")
vim.cmd("packadd! playground")

-- debugging
vim.cmd("packadd! debugprint.nvim")
require("debugprint").setup({
  create_keymaps = false,
})
