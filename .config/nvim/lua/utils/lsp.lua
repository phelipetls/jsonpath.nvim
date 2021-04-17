local M = {}

local function preview_location(location)
  local uri = location.targetUri or location.uri
  if uri == nil then return end
  local bufnr = vim.uri_to_bufnr(uri)
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    vim.fn.bufload(bufnr)
  end
  local range = location.targetRange or location.range
  local contents = vim.api.nvim_buf_get_lines(bufnr, range.start.line, range["end"].line+1, false)
  local syntax = vim.api.nvim_buf_get_option(bufnr, 'syntax')
  return vim.lsp.util.open_floating_preview(contents, syntax, { border = "single" })
end

local function preview_location_callback(_, _, result)
  if result == nil or vim.tbl_isempty(result) then
    return
  end
  if vim.tbl_islist(result) then
    preview_location(result[1])
  else
    preview_location(result)
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

  for _, client in ipairs(clients) do
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

function M.import_after_completion()
  local completed_item = vim.v.completed_item
  if
    not (completed_item and completed_item.user_data and completed_item.user_data.nvim and
      completed_item.user_data.nvim.lsp and
      completed_item.user_data.nvim.lsp.completion_item)
   then
    return
  end

  local item = completed_item.user_data.nvim.lsp.completion_item
  local bufnr = vim.api.nvim_get_current_buf()

  vim.lsp.buf_request(
    bufnr,
    "completionItem/resolve",
    item,
    function(_, _, result)
      if result and result.additionalTextEdits then
        vim.lsp.util.apply_text_edits(result.additionalTextEdits, bufnr)
      end
    end
  )
end

return M
