-- {{{ settings

vim.g.coc_global_extensions = {
  "coc-tsserver",
  "coc-pyright",
  "coc-json",
  "coc-html",
  "coc-css",
  "coc-prettier",
  "coc-syntax",
  "coc-sumneko-lua",
  "coc-rust-analyzer",
  "coc-highlight",
  "@yaegassy/coc-astro",
  "@yaegassy/coc-tailwindcss3",
}

vim.o.backup = false
vim.o.writebackup = false
vim.o.updatetime = 300
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.shortmess:append("c")
vim.o.pumheight = 10
vim.o.tagfunc = "CocTagFunc"
vim.g.coc_quickfix_open_command = "doautocmd QuickFixCmdPost | cfirst"

-- persist workspace folders
-- see https://github.com/neoclide/coc.nvim/wiki/Using-workspaceFolders#persist-workspace-folders
vim.opt.sessionoptions:append({ "globals" })

-- }}}
-- {{{ keymaps
vim.keymap.set("n", "<space>cr", "<cmd>CocRestart<CR>")

local function is_preceded_by_whitespace()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local current_line = vim.api.nvim_get_current_line()
  local prev_char = current_line:sub(col, col)
  return col == 0 or prev_char:find("%s") ~= nil
end

vim.keymap.set("i", "<Tab>", function()
  if vim.fn["coc#pum#visible"]() == 1 then
    return vim.fn["coc#pum#next"](1)
  end

  if vim.fn.pumvisible() == 1 then
    return vim.api.nvim_replace_termcodes("<C-n>", true, true, true)
  end

  if is_preceded_by_whitespace() then
    return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
  end

  if vim.fn["coc#rpc#ready"]() == 1 then
    return vim.fn["coc#refresh"]()
  end

  if vim.bo.omnifunc ~= "" then
    return vim.api.nvim_replace_termcodes("<C-x><C-o>", true, true, true)
  end

  return vim.api.nvim_replace_termcodes("<C-n>", true, true, true)
end, {
  silent = true,
  expr = true,
  replace_keycodes = false,
  desc = "Navigate to next completion item, unless there is only whitespace before cursor",
})

vim.keymap.set("i", "<S-Tab>", function()
  if vim.fn["coc#pum#visible"]() == 1 then
    return vim.fn["coc#pum#prev"](1)
  end

  if vim.fn.pumvisible() == 1 then
    return vim.api.nvim_replace_termcodes("<C-p>", true, true, true)
  end

  return vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true)
end, {
  silent = true,
  expr = true,
  replace_keycodes = false,
  desc = "Navigate to previous completion item",
})

vim.keymap.set("i", "<C-Space>", function()
  if vim.fn["coc#rpc#ready"]() then
    return vim.fn["coc#refresh"]()
  end

  if vim.bo.omnifunc ~= "" then
    return vim.api.nvim_replace_termcodes("<C-x><C-o>", true, true, true)
  end

  return ""
end, {
  silent = true,
  expr = true,
  replace_keycodes = false,
  desc = "Show completion items",
})

vim.keymap.set("i", "<CR>", function()
  if vim.fn["coc#pum#visible"]() == 1 then
    return vim.fn["coc#pum#confirm"]()
  end

  return vim.api.nvim_replace_termcodes("<C-g>u<CR><C-r>=coc#on_enter()<CR>", true, true, true)
end, {
  silent = true,
  expr = true,
  replace_keycodes = false,
  desc = "Confirm selection of a completion item with coc",
})

vim.keymap.set("n", "K", function()
  if vim.fn.CocHasProvider("hover") then
    vim.fn.CocActionAsync("doHover")
    return
  end

  vim.fn.feedkeys("K", "in")
end, { silent = true, desc = "Show LSP hover information, fallback to keywordprg" })

vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true, desc = "Jump to previous LSP diagnostic" })
vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true, desc = "Jump to next LSP diagnostic" })

vim.keymap.set("n", "[d", "<Plug>(coc-definition)", { silent = true, desc = "Go to symbol definition" })

vim.keymap.set("n", "<C-w>d", function()
  vim.fn.CocActionAsync("jumpDefinition", "split")
end, { silent = true, desc = "Open symbol definition in a horizontal split" })

vim.keymap.set("n", "<C-w><C-d>", function()
  vim.fn.CocActionAsync("jumpDefinition", "split")
end, { silent = true, desc = "Open symbol definition in a horizontal split" })

vim.keymap.set("n", "<C-w>}", function()
  vim.fn.CocActionAsync("jumpDefinition", "pedit")
end, { silent = true, desc = "Open symbol definition in a preview window" })

vim.keymap.set("n", "[t", "<Plug>(coc-type-definition)", { silent = true, desc = "Go to type definition" })

vim.keymap.set("n", "<C-space>", function()
  vim.fn.CocActionAsync("diagnosticInfo")
end, { silent = true, desc = "Show diagnostic information in a floating window" })

vim.keymap.set("n", "<M-S-O>", function()
  vim.fn.CocActionAsync("runCommand", "editor.action.organizeImport")
end, { silent = true })

vim.keymap.set("n", "<F2>", "<Plug>(coc-rename)")

vim.keymap.set("n", "<M-CR>", "<Plug>(coc-codeaction-cursor)", { desc = "Open code actions menu" })
vim.keymap.set("n", "<space>a", "<Plug>(coc-codeaction-cursor)", { desc = "Open code actions menu" })

vim.keymap.set({ "n", "v" }, "<C-d>", function()
  if vim.fn["coc#float#has_scroll"]() == 1 then
    return vim.fn["coc#float#scroll"](1)
  end

  return "<C-d>"
end, { silent = true, expr = true, nowait = true, desc = "Scroll down within coc floating window" })

vim.keymap.set({ "n", "v" }, "<C-u>", function()
  if vim.fn["coc#float#has_scroll"]() == 1 then
    return vim.fn["coc#float#scroll"](0)
  end

  return "<C-u>"
end, { silent = true, expr = true, nowait = true, desc = "Scroll up within coc floating window" })

vim.keymap.set("i", "<C-d>", function()
  if vim.fn["coc#float#has_scroll"]() == 1 then
    return "<C-r>=coc#float#scroll(1)<CR>"
  end

  return "<C-d>"
end, { silent = true, expr = true, nowait = true, desc = "Scroll down within coc floating window" })

vim.keymap.set("i", "<C-u>", function()
  if vim.fn["coc#float#has_scroll"]() == 1 then
    return "<C-r>=coc#float#scroll(0)<CR>"
  end

  return "<C-u>"
end, { silent = true, expr = true, nowait = true, desc = "Scroll up within coc floating window" })

vim.keymap.set("n", "<space>cs", "<cmd>CocList symbols<CR>", { desc = "Open list with workspace symbols" })

vim.keymap.set("n", "<space>cc", "<cmd>CocList commands<CR>", { desc = "Open list with all coc commands" })

-- }}}
-- {{{ commands
vim.api.nvim_create_user_command("References", function()
  vim.fn.CocActionAsync("jumpReferences")
end, {
  nargs = 0,
  desc = "Populate quickfix list with references of symbol under the cursor",
})

vim.api.nvim_create_user_command("Fmt", function()
  vim.fn.CocAction("format")
end, {
  nargs = 0,
  desc = "Format document with LSP",
})

-- }}}
-- vim: foldmethod=marker foldlevel=999
