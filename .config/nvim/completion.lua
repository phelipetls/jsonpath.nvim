local path_utils = require "path_utils"

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local get_last_char = function()
  local col = vim.fn.col(".") - 1
  if col == 0 then
    return
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
  elseif vim.bo.omnifunc ~= "" then
    return t "<C-x><C-o>"
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

local function is_keyword(char)
  return vim.fn.match(char, "\\k") ~= -1
end

local chars_inserted = 0

local function debounce(fn)
  local timer_id = 0
  return function(...)
    vim.fn.timer_stop(timer_id)
    timer_id = vim.fn.timer_start(200, fn)
  end
end

local debounced_complete_words =
  debounce(
  function()
    if vim.fn.mode() ~= "i" then
      return
    end
    vim.fn.feedkeys(t "<C-n>")
  end
)

_G.auto_complete = function()
  if vim.fn.reg_executing() ~= "" or vim.fn.mode() ~= "i" or vim.fn.pumvisible() == 1 then
    return
  end

  if not is_keyword(vim.v.char) then
    chars_inserted = 0
    return
  end

  chars_inserted = chars_inserted + 1

  if chars_inserted >= 3 then
    debounced_complete_words()
    return
  end
end

vim.cmd [[augroup AutoComplete]]
vim.cmd [[  au!]]
vim.cmd [[  autocmd InsertCharPre * noautocmd lua auto_complete()]]
vim.cmd [[augroup END]]

local function read_dir(dir, fn)
  local items = fn and vim.fn.readdir(dir, fn) or vim.fn.readdir(dir)

  local parsed_items =
    vim.tbl_flatten(
    vim.tbl_map(
      function(item)
        local path = path_utils.path_join(dir, item)

        if vim.fn.isdirectory(path) == 1 then
          return item .. "/"
        end

        local item_without_extension = path_utils.remove_extension(item)

        if item ~= item_without_extension then
          return {item, item_without_extension}
        end

        return item
      end,
      items
    )
  )

  table.sort(
    parsed_items,
    function(a, b)
      -- show directories first
      if vim.endswith(a, "/") and not vim.endswith(b, "/") then
        return true
      end
      if vim.endswith(b, "/") and not vim.endswith(a, "/") then
        return false
      end

      -- put hidden files at the end
      if vim.startswith(a, ".") and not vim.startswith(b, ".") then
        return false
      end
      if vim.startswith(b, ".") and not vim.startswith(a, ".") then
        return true
      end

      return false
    end
  )

  return parsed_items
end

local get_line_until_cursor = function()
  local current_line = vim.fn.getline(".")
  return string.sub(current_line, 1, vim.fn.col(".") - 1)
end

-- We can't use expand("<cfile>") in insert mode.
local get_path_under_cursor = function()
  local regex = vim.regex("\\f\\+$")

  local line_until_cursor = get_line_until_cursor()
  local match_start, match_end = regex:match_str(line_until_cursor)

  if not match_start then
    return
  end

  return string.sub(line_until_cursor, match_start + 1, match_end)
end

_G.path_completion = function()
  local path_under_cursor = get_path_under_cursor()

  if not path_under_cursor then
    return
  end

  local path = path_utils.expand_relative_fname(path_under_cursor)

  if vim.endswith(path_under_cursor, "/") then
    local items = read_dir(path)

    vim.fn.complete(vim.fn.col("."), items)
    return ""
  end

  local dir = vim.fn.fnamemodify(path, ":h")
  local fname = vim.fn.fnamemodify(path, ":t")

  local items =
    read_dir(
    dir,
    function()
      local value = vim.v.val
      if value:match("^" .. fname) then
        return 1
      end
      return 0
    end
  )

  vim.fn.complete(vim.fn.col(".") - fname:len(), items)
  return ""
end

vim.api.nvim_set_keymap("i", "<C-x><C-f>", "<C-r>=v:lua.path_completion()<CR>", {silent = true})
