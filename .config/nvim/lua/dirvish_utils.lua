local M = {}

local function get_path_under_cursor()
  return vim.fn.expand("<cfile>")
end

local function is_directory(path)
  return vim.fn.isdirectory(path) == 1
end

local function is_buf_listed(expr)
  return vim.fn.buflisted(expr) == 1
end

local function echo_err(msg)
  vim.cmd(string.format("echoerr '%s'", msg))
end

local function reload_dirvish()
  vim.cmd("Dirvish %")
end

local function get_input(...)
  return vim.fn.trim(vim.fn.input(...))
end

local function delete_buffer(expr)
  if not is_directory(expr) and is_buf_listed(expr) then
    vim.cmd("bd " .. vim.fn.bufnr(expr))
  end
end

local function delete_path(path, force)
  if force then
    return vim.fn.delete(path, "rf")
  end

  return vim.fn.delete(path, is_directory(path) == 1 and "d" or "")
end

function M.delete()
  local path = get_path_under_cursor()
  local option = vim.fn.confirm("Delete " .. path, "&Yes\n&No\n&Force", 2)

  if option == 2 then
    return
  end

  local result = delete_path(path, option == 3)

  if result == -1 then
    echo_err("Failed to remove " .. path)
    return
  end

  delete_buffer(path)
  reload_dirvish()
end

function M.create_file()
  local fname = get_input("File: ")

  if fname == "" then
    return
  end

  local path = vim.fn.expand("%") .. fname

  if vim.fn.filereadable(path) == 1 then
    echo_err("File already exists")
    vim.cmd("edit " .. path)
    return
  end

  vim.fn.writefile({}, path)

  reload_dirvish()
end

function M.create_dir()
  local dirname = get_input("Directory: ")

  if dirname == "" then
    return
  end

  local path = vim.fn.expand("%") .. dirname

  vim.fn.mkdir(path)

  reload_dirvish()
end

local function get_name(path)
  if is_directory(path) then
    return vim.fn.fnamemodify(path, ":h:t")
  end

  return vim.fn.fnamemodify(path, ":t")
end

function M.rename()
  local oldpath = get_path_under_cursor()
  local oldname = get_name(oldpath)

  local newname = get_input("Rename: ", oldname)

  if not newname or newname == "" or newname == oldname then
    return
  end

  local newpath = vim.fn.expand("%") .. newname

  local result = vim.fn.rename(oldpath, newpath)

  if result ~= 0 then
    echo_err("Failed to rename")
  end

  if _G.rename_hook and vim.is_callable(_G.rename_hook) then
    pcall(_G.rename_hook, oldpath, newpath)
  end

  delete_buffer(oldpath)
  reload_dirvish()
end

return M
