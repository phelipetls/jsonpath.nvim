-- general keymaps
vim.keymap.set("n", "gr", "gT", { desc = "Go to previous tab" })

vim.keymap.set("n", "<Esc>", function()
  vim.o.hlsearch = false
end, { silent = true, desc = "Disable highlight search" })

vim.keymap.set("n", "<space>ev", "<cmd>edit $MYVIMRC<CR>", {
  silent = true,
  desc = "Edit Neovim configuration file",
})

vim.keymap.set("n", "<space>ss", function()
  if vim.bo.filetype == "vim" or vim.fn.expand("%:t") == "init.lua" then
    vim.cmd.source("%")
    return
  end

  if vim.bo.filetype == "lua" then
    local module = vim.fn.expand("%:t:r")
    require("plenary.reload").reload_module(module)
  end
end, { desc = "Reload current Lua/VimScript file" })

vim.keymap.set("n", "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, { expr = true, desc = "Skip wrapped lines when using a count to jump lines up" })

vim.keymap.set("n", "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, { expr = true, desc = "Skip wrapped lines when using a count to jump lines down" })

vim.keymap.set("n", "'", "`", { desc = "Jump to exact location of a mark" })

vim.keymap.set("n", "<C-w><C-q>", "<cmd>close<CR>", { silent = true, desc = "Close split" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { silent = true, desc = "Move to split below" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { silent = true, desc = "Move to split above" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { silent = true, desc = "Move split at the right" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { silent = true, desc = "Move split at the left" })

vim.keymap.set("n", "<C-Left>", "<C-w>>", { silent = true, desc = "Increase split width" })
vim.keymap.set("n", "<C-Right>", "C-w><", { silent = true, desc = "Decrease split width" })
vim.keymap.set("n", "<C-Up>", "<C-w>+", { silent = true, desc = "Increase split height" })
vim.keymap.set("n", "<C-Down>", "<C-w>-", { silent = true, desc = "Decrease split height" })

vim.keymap.set("v", ">", ">gv", { silent = true, desc = "Keep selected lines when indenting" })
vim.keymap.set("v", "<", "<gv", { silent = true, desc = "Keep selected lines when deindenting" })

vim.keymap.set("n", "gy", "`[v`]", { silent = true, desc = "Select last modified/yanked text" })

vim.keymap.set("n", "Q", "", { desc = "Disable switching to Ex mode with Q" })

vim.keymap.set("n", "<C-n>", "*Ncgn", { silent = true, desc = "Substitute word under cursor" })

vim.keymap.set("n", "<M-q>", "gwip", { desc = "Format paragraph" })

vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>", { desc = "Go to start of line" })
vim.keymap.set("c", "<C-x><C-a>", "<C-a>", { desc = "Insert previously inserted text" })

vim.keymap.set("i", "<C-k>", "<C-o>D", { desc = "Delete until end of line" })
vim.keymap.set("i", "<C-x><C-k>", "<C-k>", { desc = "Insert digraph" })

vim.keymap.set("i", "<C-e>", function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]

  if col == #line then
    return "<C-e>"
  end

  return "<End>"
end, {
  expr = true,
  desc = "Go to end of line, if not already otherwise fallback to built-in behaviour of re-using character in the line above",
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
  desc = "Insert today's date in most common date formats",
})

-- <space> should not move cursor in normal mode
vim.keymap.set("n", "<space>", "")

vim.keymap.set(
  "c",
  "<C-r><C-l>",
  [[<C-R>=substitute(getline('.'), '^\s*', '', '')<CR>]],
  { desc = "Use current line in command-line mode, but strip trailing space" }
)

vim.keymap.set({ "o", "x" }, "<Tab>", "%", { desc = "Use matchit to go to matching brackets etc." })

vim.keymap.set("n", "y<C-p>", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Copy current file name" })

vim.keymap.set("n", "gd", "gd:nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "gD", "gD:nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "1gd", "1gd:nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "1gD", "1gD:nohlsearch<CR>", { silent = true })

vim.cmd([[inoreabbrev Taebl Table]])
vim.cmd([[inoreabbrev taebl table]])

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
  "<C-U><cmd>set operatorfunc=format#operatorfunc<CR>gvg@",
  { silent = true, desc = "Visual-mode operator to format lines" }
)

vim.keymap.set("n", "gQ", "<cmd>call format#file(0)<CR>", { silent = true })
vim.keymap.set("n", "<space>gQ", "<cmd>call format#file(1)<CR>", { silent = true })

-- git
for _, lhs in ipairs({ "<space>gg", "<space>g<space>" }) do
  vim.keymap.set("n", lhs, ":Git ", { silent = true, nowait = true })
end

-- unimpaired-like mappings to ignore whitespace in diff
vim.keymap.set("n", "[oi", function()
  vim.opt.diffopt:append({ "iwhite" })
end, { silent = true, desc = "Ignore whitespace in diff" })

vim.keymap.set("n", "]oi", function()
  vim.opt.diffopt:remove({ "iwhite" })
end, { silent = true, desc = "Don't ignore whitespace in diff" })

vim.keymap.set("n", "yoi", function()
  if vim.o.diffopt:match("iwhite") then
    vim.opt.diffopt:remove({ "iwhite" })
  else
    vim.opt.diffopt:append({ "iwhite" })
  end
end, { silent = true, desc = "Toggle ignoring whitespace in diff" })

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

vim.keymap.set("n", "<space>q", function()
  qflist.toggle()
end, { silent = true, desc = "Toggle location list" })

vim.keymap.set("n", "<space>l", function()
  loclist.toggle()
end, { silent = true, desc = "Toggle location list" })

-- close tag
vim.keymap.set(
  "i",
  "<C-x>/",
  "</<C-r>=v:lua.require('helpers.close_tag').close_tag()<CR><C-r>=v:lua.require('helpers.close_tag').reindent()<CR><C-r>=v:lua.require('helpers.close_tag').cleanup()<CR>",
  { silent = true }
)

-- textobjects
_G.select_number = function()
  vim.fn.search([[\d\>]], "cW")
  vim.cmd.normal({ args = "v", bang = true })
  vim.fn.search([[\<\d]], "becW")
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
