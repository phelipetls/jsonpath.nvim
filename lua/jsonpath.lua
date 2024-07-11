local M = {}

local ts_utils = require("nvim-treesitter.ts_utils")

---@param bufnr number The buffer number to use. If none, the current buffer will be used
local get_node_text = function(node, bufnr)
    bufnr = bufnr or 0
  return vim.treesitter.get_node_text(node, bufnr)
end

local get_string_content = function(node, bufnr)
    bufnr = bufnr or 0

  for _, child in ipairs(ts_utils.get_named_children(node)) do
    if child:type() == "string_content" then
      return get_node_text(child, bufnr)
    end
  end

  return ""
end

local starts_with_number = function(str)
  return str:match("^%d")
end

local contains_special_characters = function(str)
  return str:match("[^a-zA-Z0-9_]")
end

---Create a jsonpath based of `node`. 
---If no node is provided, it will use the node at the cursor for the current buffer.
---@param start_node unknown The node to create the jsonpath from.
---@param bufnr number The buffer number to use. If none, the current buffer will be used
M.get = function(start_node, bufnr)
    bufnr = bufnr or 0
  if pcall(function() vim.treesitter.get_parser(bufnr) end) ~= true then
    return ""
  end

  local current_node = start_node or vim.treesitter.get_node()
  if not current_node then
    return ""
  end

  local accessors = {}
  local node = current_node

  while node do
    local accessor = ""

    if node:type() == "pair" then
      local key_node = unpack(node:field("key"))
      local key = get_string_content(key_node, bufnr)

      if key and starts_with_number(key) or contains_special_characters(key) then
        accessor = string.format('["%s"]', key)
      else
        accessor = string.format("%s", key)
      end
    end

    if node:type() == "array" then
      accessor = "[]"

      for i, child in ipairs(ts_utils.get_named_children(node)) do
        if ts_utils.is_parent(child, current_node) then
          accessor = string.format("[%d]", i - 1)
        end
      end
    end

    if accessor ~= "" then
      table.insert(accessors, 1, accessor)
    end

    node = node:parent()
  end

  if #accessors == 0 then
    return "."
  end

  local path = ""

  for i, accessor in ipairs(accessors) do
    if i == 1 then
      path = path .. "." .. accessor
    elseif vim.startswith(accessor, "[") then
      path = path .. accessor
    else
      path = path .. "." .. accessor
    end
  end

  return path
end

return M
