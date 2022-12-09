local M = {}

local old_omnifunc

M.close_tag = function()
  old_omnifunc = vim.bo.omnifunc
  vim.bo.omnifunc = "htmlcomplete#CompleteTags"
  return vim.api.nvim_replace_termcodes("<C-x><C-o><C-n><C-y>", true, true, true)
end

M.reindent = function()
  if vim.bo.indentexpr ~= "" or vim.bo.cindent ~= "" then
    return vim.api.nvim_replace_termcodes("<C-F>", true, true, true)
  end
end

M.cleanup = function()
  vim.bo.omnifunc = old_omnifunc
  return ""
end

return M
