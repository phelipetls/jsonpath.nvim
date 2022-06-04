local M = {}

function M.path_exists(path)
  return vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1
end

function M.path_join(...)
  return vim.fn.simplify(table.concat({ ... }, "/"))
end

return M
