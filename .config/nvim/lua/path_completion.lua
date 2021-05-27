local M = {}

local path_utils = require "utils/path"

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

function M.complete()
  local path_under_cursor = get_path_under_cursor()

  if not path_under_cursor then
    return
  end

  local expanded_path_under_cursor = path_utils.expand_relative_fname(path_under_cursor)

  local dir = vim.fn.fnamemodify(expanded_path_under_cursor, ":h")
  local fname = vim.fn.fnamemodify(expanded_path_under_cursor, ":t")

  local items =
    read_dir(
    dir,
    function()
      if vim.v.val:match("^" .. fname) then
        return 1
      end
      return 0
    end
  )

  vim.fn.complete(vim.fn.col(".") - fname:len(), items)
  return ""
end

return M
