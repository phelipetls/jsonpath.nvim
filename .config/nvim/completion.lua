local path_utils = require "utils/path"

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local get_last_char = function()
  local col = vim.fn.col(".") - 1
  if col == 0 then
    return " "
  end
  return vim.fn.getline("."):sub(col, col)
end

local last_char_is_whitespace = function()
  return get_last_char():match("%s")
end

local last_char_is_slash = function()
  return get_last_char():match("/")
end

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif last_char_is_whitespace() then
    return t "<Tab>"
  elseif last_char_is_slash() then
    return t "<C-x><C-f>"
  else
    return t "<C-n>"
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

_G.ctrl_space = function()
  if vim.bo.omnifunc ~= "" then
    return t "<C-x><C-o>"
  end
end

vim.api.nvim_set_keymap("i", "<C-Space>", "v:lua.ctrl_space()", {expr = true, silent = true})
vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<C-x><C-f>", [[<C-r>=luaeval("require'path_completion'.complete()")<CR>]], {silent = true})
