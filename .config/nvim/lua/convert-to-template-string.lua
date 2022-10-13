local M = {}

local ts_utils = require("nvim-treesitter.ts_utils")

local replace_surroundings_with = function(node, char)
  local start_row, start_col, end_row, end_col = node:range()

  vim.api.nvim_buf_set_text(0, start_row, start_col, start_row, start_col + 1, { char })
  vim.api.nvim_buf_set_text(0, end_row, end_col - 1, end_row, end_col, { char })
end

M.convert = function()
  local node = ts_utils.get_node_at_cursor()

  local is_string = node:type() == "string"

  if not is_string then
    local parent = node:parent()

    if parent:type() == "string" then
      node = parent
    else
      -- the node under the cursor is not a string, nor a child of a string.
      -- nothing to be done.
      return
    end
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
