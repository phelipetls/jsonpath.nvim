local M = {}

function M.get_current_file_dir()
  return vim.fn.expand("%:p:h")
end

function M.path_exists(path)
  return vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1
end

function M.path_join(...)
  return vim.fn.simplify(table.concat({...}, "/"))
end

function M.remove_extension(fname)
  return vim.fn.fnamemodify(fname, ":r")
end

return M
