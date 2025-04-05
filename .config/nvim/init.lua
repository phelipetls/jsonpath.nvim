-- {{{ plugins

vim.loader.enable()

vim.g.mapleader = " "

-- prevent loading netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- builtin plugin
vim.cmd("packadd! cfilter")

-- optimization
vim.cmd("packadd! LargeFile")

-- utilities/dependencies
vim.cmd("packadd! plenary.nvim")

vim.cmd("packadd! vim-dispatch")
vim.g.dispatch_no_maps = 1

vim.cmd("packadd! statuscol.nvim")
require("statuscol").setup({
  segments = {
    { text = { require("statuscol.builtin").lnumfunc }, click = "v:lua.ScLa" },
    { text = { require("statuscol.builtin").foldfunc }, click = "v:lua.ScFa" },
    { text = { " " } },
  },
})

-- text editing
vim.cmd("packadd! vim-surround")
vim.cmd("packadd! vim-repeat")
vim.cmd("packadd! vim-unimpaired")
vim.cmd("packadd! vim-speeddating")
vim.cmd("packadd! vim-abolish")
vim.cmd("packadd! vim-lion")
vim.cmd("packadd! vim-sleuth")

vim.cmd("packadd! vim-commentary")

vim.cmd("packadd! undotree")
vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { silent = true })

vim.cmd("packadd! dsf.vim")
vim.g.dsf_no_mappings = 1
vim.keymap.set("n", "dsf", "<Plug>DsfNextDelete")
vim.keymap.set("n", "csf", "<Plug>DsfNextChange")

vim.cmd("packadd! inline_edit.vim")
vim.keymap.set("n", "<C-c>", "<cmd>InlineEdit<CR>")
vim.g.inline_edit_autowrite = 1

vim.cmd("packadd! treesj")
require("treesj").setup({
  use_default_keymaps = false,
})
vim.keymap.set("n", "gJ", "<cmd>TSJJoin<CR>")
vim.keymap.set("n", "gS", "<cmd>TSJSplit<CR>")

-- git
vim.cmd("packadd! vim-fugitive")
-- avoid showing ansi escape sequences in nvim terminal
-- such as in lint-staged output before committing
vim.g.fugitive_pty = 0

vim.cmd("packadd! gv.vim")
vim.cmd("packadd! vim-rhubarb")
vim.cmd("packadd! fugitive-gitlab.vim")
vim.cmd("packadd! vim-fugitive-blame-ext")

vim.cmd("packadd! vim-twiggy")
vim.g.twiggy_group_locals_by_slash = 0
vim.g.twiggy_local_branch_sort = "mru"
vim.g.twiggy_adapt_columns = 0
vim.g.twiggy_show_full_ui = 0

-- file navigation
vim.cmd("packadd! vim-dirvish")
vim.g.dirvish_mode = [[:sort ,^.*[\/],]]

-- fuzzy finder
vim.cmd("packadd! fzf-lua")
require("plugins.config.fzf_lua")

-- lsp
vim.cmd("packadd! coc.nvim")
require("plugins.config.coc")

-- session management
vim.cmd("packadd! vim-obsession")
vim.g.obsession_no_bufenter = 1

-- repl
vim.cmd("packadd! vim-slime")
require("plugins.config.slime")

-- json
vim.cmd("packadd! jsonpath.nvim")
vim.cmd("packadd! vim-jqplay")
vim.g.jqplay = {
  mods = "vertical",
}

-- web development
vim.cmd("packadd! vim-hugo")

-- treesitter
vim.cmd("packadd! nvim-treesitter")
vim.cmd("packadd! nvim-ts-context-commentstring")
vim.cmd("packadd! nvim-treesitter-textobjects")
require("plugins.config.treesitter")

-- testing
vim.cmd("packadd! vim-test")
vim.g["test#strategy"] = "dispatch"
vim.g["dispatch_compilers"] = {
  npx = "",
  yarn = "",
  ["node_modules/.bin/"] = "",
}
vim.g["test#transformation"] = "strip-ansi"
vim.g["test#custom_transformations"] = {
  ["strip-ansi"] = function(cmd)
    return cmd .. " | strip-ansi"
  end,
}

-- }}}
-- {{{ settings

vim.cmd("filetype plugin indent on")

vim.o.ruler = false
vim.o.wildmode = "full"
vim.o.lazyredraw = true
vim.o.mouse = "nv"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showcmd = false
vim.o.cursorline = false
vim.o.scrolloff = 3
vim.o.backspace = "indent,eol,start"
vim.o.laststatus = 2
vim.o.showmode = true
vim.o.updatetime = 1000
vim.o.breakindent = true
vim.o.breakindentopt = "shift:2"
vim.o.linebreak = true
vim.o.showtabline = 2
vim.o.sidescroll = 1
vim.o.sidescrolloff = 1

-- colorscheme
vim.cmd.set("termguicolors")
vim.cmd.colorscheme('sorbet')

-- clipboard
if vim.fn.has("wsl") == 1 then
  if vim.fn.executable("win32yank.exe") == 1 then
    vim.g.clipboard = {
      name = "win32yank",
      copy = {
        ["+"] = "win32yank.exe -i --crlf",
        ["*"] = "win32yank.exe -i --crlf",
      },
      paste = {
        ["+"] = "win32yank.exe -o --lf",
        ["*"] = "win32yank.exe -o --lf",
      },
      cache_enabled = 0,
    }
  else
    vim.g.clipboard = {
      name = "Windows",
      copy = {
        ["+"] = "clip.exe",
        ["*"] = "clip.exe",
      },
      paste = {
        ["+"] = [[powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))]],
        ["*"] = [[powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))]],
      },
      cache_enabled = 0,
    }
  end
end

vim.keymap.set("n", "<space>y", [["+y]])
vim.keymap.set("n", "<space>Y", [["+Y]])
vim.keymap.set("n", "<space>p", [["+p]])
vim.keymap.set("n", "<space>P", [["+P]])

vim.keymap.set("v", "<space>p", [["+p]])
vim.keymap.set("v", "<space>y", [["+y]])

vim.keymap.set("n", "<space>[p", [["+[p]], { remap = true })
vim.keymap.set("n", "<space>[P", [["+[P]], { remap = true })

vim.keymap.set("n", "<space>]p", [["+]p]], { remap = true })
vim.keymap.set("n", "<space>]P", [["+]P]], { remap = true })

vim.keymap.set("n", "<space><p", [["+<p]], { remap = true })
vim.keymap.set("n", "<space><P", [["+<P]], { remap = true })

vim.keymap.set("n", "<space>>p", [["+>p]], { remap = true })
vim.keymap.set("n", "<space>>P", [["+>P]], { remap = true })

vim.keymap.set("n", "<space>=p", [["+=p]], { remap = true })
vim.keymap.set("n", "<space>=P", [["+=P]], { remap = true })

-- tabline
vim.o.tabline = "%!v:lua.require('helpers.tabline').get()"

-- statusline
vim.o.statusline = "%!v:lua.require('helpers.statusline').get()"

-- file navigation
vim.opt.path = { ".", "", ".." }

-- ignore these files while browsing
vim.opt.wildignore = {
  "venv*/",
  "__pycache__/",
  ".pytest_cache/",
  "tags",
  "htmlcov/.coverage",
  "*.pyc",
  "package-lock.json",
  "yarn.lock",
}

-- tell neovim where python3, to improve startup time
if vim.fn.executable("/usr/bin/python3") == 1 then
  vim.g.loaded_python_provider = 0
  vim.g.python3_host_prog = "/usr/bin/python3"
end

vim.opt.diffopt = {
  "closeoff",
  "filler",
  "foldcolumn:2",
  "hiddenoff",
  "indent-heuristic",
  "internal",
  "algorithm:patience",
  "linematch:50"
}

-- visually show special characters
vim.o.list = true

vim.opt.fillchars = {
  fold = "-",
  foldopen = "-",
  foldclose = "+",
  foldsep = " ",
  vert = "┃",
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vertleft = "┨",
  vertright = "┣",
  verthoriz = "╋",
  diff = "/",
}

vim.opt.listchars = {
  tab = "» ",
  nbsp = "¬",
  trail = "·",
  extends = "…",
  precedes = "‹",
}

vim.o.showbreak = "↳ "

-- use ripgrep as the external grep command
if vim.fn.executable("rg") == 1 then
  vim.o.grepprg = "rg --vimgrep --smart-case --hidden"
  vim.o.grepformat = "%f:%l:%c:%m"
end

-- disable colors in deno and nodejs terminal output
vim.env.NO_COLOR = 0
vim.env.FORCE_COLOR = 0

-- remove -F flag I use in my .profile, that would automatically close terminal
-- window if output in less is too short
vim.env.LESS = "RX"

-- }}}
-- {{{ keymaps

vim.keymap.set("n", "gr", "gT", { nowait = true })

-- <space> should not move cursor in normal mode
vim.keymap.set("n", "<space>", "")

vim.keymap.set({ "o", "x" }, "<Tab>", "%", { remap = true })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })

vim.keymap.set("n", "<leader>ev", "<cmd>edit $MYVIMRC<CR>", { silent = true })

vim.keymap.set("n", "<leader>ss", "<cmd>source %<CR>")

vim.keymap.set({ "x", "n" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set({ "x", "n" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

vim.keymap.set("n", "'", "`")

vim.keymap.set("n", "<C-w><C-q>", "<cmd>close<CR>", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { silent = true })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { silent = true })

vim.keymap.set("n", "<C-Left>", "<C-w>>", { silent = true })
vim.keymap.set("n", "<C-Right>", "C-w><", { silent = true })
vim.keymap.set("n", "<C-Up>", "<C-w>+", { silent = true })
vim.keymap.set("n", "<C-Down>", "<C-w>-", { silent = true })

vim.keymap.set("v", ">", ">gv", { silent = true })
vim.keymap.set("v", "<", "<gv", { silent = true })

vim.keymap.set("n", "gy", "`[v`]", { silent = true })

vim.keymap.set("n", "<C-n>", "*Ncgn", { silent = true })

vim.keymap.set("n", "<M-q>", "gwip")

vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>")
vim.keymap.set("c", "<C-x><C-a>", "<C-a>")

vim.keymap.set("i", "<C-k>", "<C-o>D")
vim.keymap.set("i", "<C-x><C-k>", "<C-k>")

vim.keymap.set("i", "<C-e>", function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]

  if col == #line then
    return "<C-e>"
  end

  return "<End>"
end, {
  expr = true,
  desc = "Go to end of line if not already there, otherwise insert character in the line above",
})

-- autocomplete dates
_G.get_formatted_dates = function()
  local date_formats = { "%Y-%m-%d", "%Y-%m-%dT%H:%M:%S%Z" }

  local dates = vim.tbl_map(function(date_format)
    return vim.fn.strftime(date_format)
  end, date_formats)

  return dates
end

vim.keymap.set("i", "<C-g><C-t>", "<C-r>=repeat(complete(col('.'),v:lua.get_formatted_dates()),0)<CR>", {
  silent = true,
  nowait = true,
})

vim.keymap.set("n", "y<C-p>", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Copy current file name" })

vim.keymap.set("n", "gb", function()
  require("helpers.gitblame").blame_current_line()
end, { silent = true, desc = "Blame current line with fugitive" })

-- gx
vim.g.netrw_nogx = 1
vim.keymap.set({ "n", "v" }, "gx", function()
  require("helpers.os").open_under_cursor()
end, { silent = true, desc = "Open file/URL under cursor" })

-- formatting
vim.keymap.set(
  "n",
  "gq",
  "<cmd>set operatorfunc=format#operatorfunc<CR>g@",
  { silent = true, desc = "Normal-mode operator to format lines" }
)
vim.keymap.set(
  "v",
  "gq",
  "<cmd>set operatorfunc=format#operatorfunc<CR>gvg@",
  { silent = true, desc = "Visual-mode operator to format lines" }
)

vim.keymap.set("n", "gQ", "<cmd>call format#file()<CR>", { silent = true })

-- git
vim.api.nvim_set_keymap("n", "<leader>gg", ":Git<space>", { noremap = true })

-- unimpaired-like mappings to ignore whitespace in diff
local function ignore_whitespace_in_diff()
  vim.opt.diffopt:append({ "iwhite" })
  vim.cmd.echomsg("'setlocal diffopt+=iwhite'")
end

local function show_whitespace_in_diff()
  vim.opt.diffopt:remove({ "iwhite" })
  vim.cmd.echomsg("'setlocal diffopt-=iwhite'")
end

local function toggle_whitespace_in_diff()
  if vim.o.diffopt:match("iwhite") then
    show_whitespace_in_diff()
  else
    ignore_whitespace_in_diff()
  end
end

vim.keymap.set("n", "[oi", ignore_whitespace_in_diff, { desc = "Ignore whitespace in diff" })
vim.keymap.set("n", "]oi", show_whitespace_in_diff, { desc = "Don't ignore whitespace in diff" })
vim.keymap.set("n", "yoi", toggle_whitespace_in_diff, { desc = "Toggle ignoring whitespace in diff" })

-- quickfix and location list
local qflist = require("helpers.qflist")
local loclist = require("helpers.qflist")

vim.keymap.set("n", "]q", function()
  qflist.next()
end, { silent = true, desc = "Wrap around when navigating the quickfix list forward" })

vim.keymap.set("n", "[q", function()
  qflist.prev()
end, { silent = true, desc = "Wrap around when navigating the quickfix list backwards" })

vim.keymap.set("n", "]l", function()
  loclist.next()
end, { silent = true, desc = "Wrap around when navigating the location list forward" })

vim.keymap.set("n", "[l", function()
  loclist.prev()
end, { silent = true, desc = "Wrap around when navigating the location list backwards" })

vim.keymap.set("n", "<leader>q", function()
  qflist.toggle()
end, { silent = true, desc = "Toggle location list" })

vim.keymap.set("n", "<leader>l", function()
  loclist.toggle()
end, { silent = true, desc = "Toggle location list" })

-- textobjects
_G.select_number = function()
  vim.fn.search([[\d\([^0-9\.]\|$\)]], "cW")
  vim.cmd("normal! v")
  vim.fn.search([[\(^\|[^0-9\.]\d\)]], "becW")
end

vim.keymap.set("x", "in", ":<C-u>lua=select_number()<CR>", { silent = true, desc = "Select nearest number" })
vim.keymap.set("o", "in", "<cmd>normal vin<CR>", { desc = "Operator pending for the nearest number" })

vim.keymap.set("x", "ir", "i[", { silent = true, desc = "Select everything inside brackets" })
vim.keymap.set("o", "ir", "<cmd>normal vi[<CR>", { desc = "Operator pending mode for everything inside brackets" })

vim.keymap.set("x", "ar", "a[", { silent = true, desc = "Select everything around brackets" })
vim.keymap.set("o", "ar", "<cmd>normal va[<CR>", { silent = true, desc = "Operator for everything around brackets" })

for _, char in ipairs({ "_", "-", "/", "*", "," }) do
  vim.keymap.set(
    "x",
    "i" .. char,
    (":<C-u>normal! T%svt%s<CR>"):format(char, char),
    { desc = string.format("Select everything inside character %s", char), silent = true }
  )

  vim.keymap.set(
    "o",
    "i" .. char,
    (":<C-u>normal vi%s<CR>"):format(char),
    { desc = string.format("Operator for everything inside character %s", char), silent = true }
  )

  vim.keymap.set(
    "x",
    "a" .. char,
    (":<C-u>normal! F%svf%s<CR>"):format(char, char),
    { desc = string.format("Select everything around character %s", char), silent = true }
  )

  vim.keymap.set(
    "o",
    "a" .. char,
    (":<C-u>normal va%s<CR>"):format(char),
    { desc = string.format("Operator for everything around character %s", char), silent = true }
  )
end

-- }}}
-- {{{ commands

vim.api.nvim_create_user_command("E", "e<bang>", { bang = true, complete = "file_in_path", nargs = "*" })
vim.api.nvim_create_user_command("W", "w<bang>", { bang = true })
vim.api.nvim_create_user_command("Q", "q<bang>", { bang = true })
vim.api.nvim_create_user_command("Qall", "qall<bang>", { bang = true })

vim.api.nvim_create_user_command("Browse", function(opts)
  require("helpers.os").open(opts.fargs[1])
end, { desc = "Open file/URLs using operating system's preferred program", nargs = 1 })

vim.api.nvim_create_user_command("Hi", function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))

  local syn_id = vim.fn.synID(line, col, 0)
  local highlight_name = vim.fn.synIDattr(syn_id, "name")

  vim.cmd.hi(highlight_name ~= "" and highlight_name or nil)
end, { desc = "Show information about highlight group under cursor" })

vim.api.nvim_create_user_command("Redir", function(opts)
  vim.fn["redir#redir"](opts.args, opts.range, opts.line1, opts.line2)
end, { bar = true, range = true, nargs = 1, complete = "command", desc = "Redirect output of Vim command" })

-- }}}
-- {{{ autocmds

local global_autocmds = vim.api.nvim_create_augroup("Global", {})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = global_autocmds,
  pattern = { "*" },
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Don't autocomment on newline",
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  group = global_autocmds,
  pattern = { "*" },
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") and not vim.bo.filetype:match("git") then
      vim.cmd.normal('g`"')
    end
  end,
  desc = "Recover last cursor position when opening a file, except on git commits etc.",
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = global_autocmds,
  pattern = { "*" },
  command = "wincmd =",
  desc = "Automatically resize splits when Neovim is resized",
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = global_autocmds,
  pattern = { "*" },
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local basename = vim.fs.basename(bufname)
    vim.fn.setreg("f", basename)
  end,
  desc = "Put the current file name under the f register",
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = global_autocmds,
  pattern = { "*" },
  callback = function()
    local path = vim.fn.expand("<afile>:p")

    if vim.startswith(path, "fugitive:///") then
      return
    end

    vim.fn.mkdir(vim.fs.dirname(path), "p")
  end,
  desc = "Create intermediate directories automatically before saving file",
})

vim.api.nvim_create_autocmd({ "VimResume", "FocusGained" }, {
  group = global_autocmds,
  pattern = { "*" },
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd.checktime()
    end
  end,
  desc = "Automatically update file when Neovim resumes",
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = global_autocmds,
  pattern = { "*" },
  callback = function()
    vim.highlight.on_yank({ higroup = "Search", on_visual = false })
  end,
  desc = "Highlight yanked region",
})

local open_file_autocmds = vim.api.nvim_create_augroup("OpenFileWithF5", { clear = true })

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = open_file_autocmds,
  pattern = { "html", "dirvish", "svg" },
  callback = function()
    vim.keymap.set("n", "<F5>", function()
      require("helpers.os").open(vim.fn.expand("%:p"))
    end, { desc = "Open current file with the operating system" })
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = global_autocmds,
  pattern = { "*" },
  callback = function(ev)
    local filetype = vim.api.nvim_buf_get_option(ev.buf, "filetype")

    if
      filetype == "markdown"
      or filetype == "mdx"
      or filetype == "latex"
      or filetype == "tex"
      or filetype == "gitcommit"
    then
      vim.wo.spell = true
      vim.bo.spelllang = "pt,en_us"
    else
      vim.wo.spell = false
      vim.bo.spelllang = nil
    end
  end,
  desc = "Activate spellcheck only for specific file types",
})

local quickfix_autocmds = vim.api.nvim_create_augroup("Quickfix", { clear = true })

vim.api.nvim_create_autocmd({ "QuickFixCmdPost" }, {
  group = quickfix_autocmds,
  pattern = { "*" },
  callback = function()
    require("helpers.qflist").open()
  end,
  desc = "Open Quickfix list automatically",
})

vim.api.nvim_create_autocmd({ "WinEnter" }, {
  group = quickfix_autocmds,
  pattern = { "*" },
  callback = function()
    if vim.fn.winnr("$") == 1 and vim.o.buftype == "quickfix" then
      vim.cmd.quit()
    end
  end,
  desc = "Close quickfix list if it's the last window",
})

-- }}}
-- vim: foldmethod=marker foldlevel=999
