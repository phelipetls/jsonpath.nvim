local M = {}

local function preview_location_callback(_, _, result)
  if result == nil or vim.tbl_isempty(result) then
    return
  end
  if vim.tbl_islist(result) then
    vim.lsp.util.preview_location(result[1])
  else
    vim.lsp.util.preview_location(result)
  end
end

function M.peek_definition()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/definition", params, preview_location_callback)
end

function M.definition_sync()
  local params = vim.lsp.util.make_position_params()
  local clients, err = vim.lsp.buf_request_sync(0, "textDocument/definition", params, 1000)

  if err or not clients or vim.tbl_isempty(clients) then
    require "rg_find".rg_find()
    return
  end

  local results = {}

  for i, client in ipairs(clients) do
    if client.result and not vim.tbl_isempty(client.result) then
      vim.list_extend(results, client.result)
    end
  end

  if vim.tbl_isempty(results) then
    return
  end

  if results[1] then
    vim.lsp.util.jump_to_location(results[1])
  end

  if #results > 1 then
    vim.lsp.util.set_qflist(vim.lsp.util.locations_to_items(results))
  end
end

return M
