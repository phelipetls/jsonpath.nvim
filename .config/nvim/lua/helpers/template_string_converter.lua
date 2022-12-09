local M = {}

local replace_surroundings_with = function(node, char)
  local start_row, start_col, end_row, end_col = node:range()

  vim.api.nvim_buf_set_text(0, start_row, start_col, start_row, start_col + 1, { char })
  vim.api.nvim_buf_set_text(0, end_row, end_col - 1, end_row, end_col, { char })
end

M.is_node_at_cursor_a_string = function()
  local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()

  if not node then
    return false
  end

  local is_string = node:type() == "string"
  local is_parent_string = node:parent() and node:parent():type() == "string"

  return is_string or is_parent_string
end

M.convert = function()
  local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()

  if not node then
    return
  end

  local is_string = node:type() == "string"
  local is_parent_string = node:parent() and node:parent():type() == "string"

  if not (is_string or is_parent_string) then
    return
  end

  if is_parent_string then
    node = node:parent()
  end

  local has_interpolation = false

  for child in node:iter_children() do
    local child_text = vim.treesitter.query.get_node_text(child, 0)

    has_interpolation = child_text:match("${")

    if has_interpolation then
      break
    end
  end

  if has_interpolation then
    replace_surroundings_with(node, "`")
  end
end

return M
