vim.cmd("filetype plugin indent on")

vim.o.termguicolors = true
vim.o.number = false
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
vim.o.showmode = false
vim.o.updatetime = 1000
vim.o.breakindent = true
vim.o.breakindentopt = "shift:2"
vim.o.linebreak = true
vim.o.showtabline = 2

-- clipboard
vim.opt.clipboard:append({ "unnamedplus" })

if vim.fn.has("wsl") == 1 then
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
  }
end

-- tabline
vim.o.tabline = "%{%v:lua.require('helpers.tabline').get()%}"

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
}

-- tell neovim where python3 is -- this improves startup time
if vim.fn.executable("/usr/bin/python3") == 1 then
  vim.g.loaded_python_provider = 0
  vim.g.python3_host_prog = "/usr/bin/python3"
end

vim.opt.diffopt:append({
  foldcolumn = 0,
  hiddenoff = true,
  ["indent-heuristic"] = true,
  internal = true,
  algorithm = "patience",
})

-- visually show special characters
vim.o.list = true

vim.opt.fillchars = {
  fold = "-",
  vert = "┃",
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vertleft = "┨",
  vertright = "┣",
  verthoriz = "╋",
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

-- alias for vim.pretty_print
_G.pp = vim.pretty_print

-- persist workspace folders
-- see https://github.com/neoclide/coc.nvim/wiki/Using-workspaceFolders#persist-workspace-folders
vim.opt.sessionoptions:append({ "globals" })

-- disable colors in deno and nodejs terminal output
vim.env.NO_COLOR = 0

-- avoid showing ansi escape sequences in nvim terminal
-- such as in lint-staged output before committing
vim.g.fugitive_pty = 0

-- remove -F flag I use in my .profile, that would automatically close terminal
-- window if output in less is too short
vim.env.LESS = "RX"
