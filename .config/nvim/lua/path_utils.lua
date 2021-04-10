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

function M.expand_curdir(relative_fname)
  local fname = relative_fname:gsub("%.", get_current_file_dir())
  return fname
end

function M.expand_parentdir(relative_fname, dir)
  local fname, parentdir_count = relative_fname:gsub("%.%./", "")
  local parentdir_path = vim.fn.fnamemodify(dir or M.get_current_file_dir(), string.rep(":h", parentdir_count))
  return M.path_join(parentdir_path, fname)
end

function M.expand_relative_fname(fname)
  if vim.startswith(fname, "../") then
    return M.expand_parentdir(fname)
  elseif vim.startswith(fname, "./") then
    return M.expand_curdir(fname)
  end
  return vim.fn.expand(fname)
end

function M.remove_extension(fname)
  return vim.fn.fnamemodify(fname, ":r")
end

return M
