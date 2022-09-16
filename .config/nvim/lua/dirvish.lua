local M = {}

local path_utils = require("path")

local function echoerr(msg)
  vim.cmd("echohl WarningMsg")
  vim.cmd(string.format("echomsg '%s'", msg))
  vim.cmd("echohl None")
end

local function reload_dirvish()
  vim.cmd("Dirvish %")
end

local function get_input(...)
  local input = vim.fn.trim(vim.fn.input(...))
  vim.cmd("redraw!")
  return input
end

local function delete_dir_buffers(deleted_dir)
  for bufnr = 1, vim.fn.bufnr("$") do
    if vim.fn.buflisted(bufnr) == 1 then
      local buf_path = vim.api.nvim_buf_get_name(bufnr)

      if buf_path:find(deleted_dir, 1, true) then
        vim.cmd("silent! bdelete " .. bufnr)
      end
    end
  end
end

local function delete_file_buffer(fname)
  if vim.fn.buflisted(fname) == 1 then
    vim.cmd("silent! bdelete " .. vim.fn.bufnr(fname))
  end
end

local function get_clear_buffers_function(expr)
  if vim.fn.isdirectory(expr) == 1 then
    return delete_dir_buffers
  end

  return delete_file_buffer
end

function M.delete()
  local path = vim.fn.getline(".")
  local option = vim.fn.confirm("Delete " .. path, "&Yes\n&No", 2)

  if option == 0 or option == 2 then
    return
  end

  local clear_buffers = get_clear_buffers_function(path)

  local result
  if vim.fn.isdirectory(path) == 1 then
    result = vim.fn.delete(path, "rf")
  else
    result = vim.fn.delete(path, "")
  end

  if result == -1 then
    echoerr("Failed to delete " .. path)
    return
  end

  clear_buffers(path)
  reload_dirvish()
end

local function search(basename)
  local pattern = string.format("\\<%s\\>", basename)
  vim.fn.search(pattern, "w")
end

function M.create_file()
  local fname = get_input("File: ")

  if fname == "" then
    return
  end

  local path = vim.fn.expand("%") .. fname

  if vim.fn.filereadable(path) == 1 then
    echoerr("File already exists")
    return
  end

  local result = vim.fn.writefile({}, path)

  if result == -1 then
    echoerr("Failed to create file " .. fname)
    return
  end

  reload_dirvish()
  search(fname)
end

function M.create_dir()
  local dirname = get_input("Directory: ")

  if dirname == "" then
    return
  end

  local path = vim.fn.expand("%") .. dirname

  local result = vim.fn.mkdir(path)

  if result == -1 then
    echoerr("Failed to create directory " .. dirname)
    return
  end

  reload_dirvish()
  search(dirname)
end

local function get_basename(path)
  if vim.fn.isdirectory(path) == 1 then
    return vim.fn.fnamemodify(path, ":h:t")
  end

  return vim.fn.fnamemodify(path, ":t")
end

function M.rename()
  local old_path = vim.fn.getline(".")
  local old_basename = get_basename(old_path)

  local new_name = get_input("Rename: ", old_basename)

  if not new_name or new_name == "" or new_name == old_basename then
    return
  end

  local new_path = vim.fn.expand("%") .. new_name

  local clear_buffers = get_clear_buffers_function(old_path)
  local result = vim.fn.rename(old_path, new_path)

  if result ~= 0 then
    echoerr("Failed to rename")
    return
  end

  for winnr = 1, vim.fn.winnr("$") do
    local winbuf = vim.api.nvim_buf_get_name(vim.fn.winbufnr(winnr))
    if winbuf == old_path then
      vim.cmd(string.format("%dwincmd w", winnr))
      vim.cmd(string.format("edit %s", new_path))
      vim.cmd("wincmd p")
    end
  end

  clear_buffers(old_path)
  reload_dirvish()
  search(new_name)
end

function M.clear_arglist()
  vim.cmd("%argdelete")
  vim.cmd("echomsg 'arglist: cleared'")
  reload_dirvish()
end

return M
