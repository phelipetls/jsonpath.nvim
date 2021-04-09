local M = {}

local function get_path_under_cursor()
  return vim.fn.expand("<cfile>")
end

local function is_directory(path)
  return vim.fn.isdirectory(path) == 1
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

local function is_inside_directory(path, dir)
  return string.find(dir, path, 1, true)
end

local function delete_dir_buffers(path)
  for bufnr = 1, vim.fn.bufnr("$") do
    if bufnr ~= vim.fn.bufnr("%") and vim.fn.bufexists(bufnr) == 1 then
      local bufpath = vim.api.nvim_buf_get_name(bufnr)

      if is_inside_directory(path, bufpath) then
        vim.cmd("bd " .. bufnr)
      end
    end
  end
end

local function delete_file_buffer(fname)
  if vim.fn.buflisted(fname) == 1 then
    vim.cmd("bd " .. vim.fn.bufnr(fname))
  end
end

local function get_clear_buffers_function(expr)
  if is_directory(expr) then
    return delete_dir_buffers
  end

  return delete_file_buffer
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

  local force = option == 3
  local clear_buffers = get_clear_buffers_function(path)
  local result = delete_path(path, force)

  if result == -1 then
    echo_err("Failed to remove " .. path)
    return
  end

  clear_buffers(path)
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

  local clear_buffers = get_clear_buffers_function(oldpath)
  local result = vim.fn.rename(oldpath, newpath)

  if result ~= 0 then
    echo_err("Failed to rename")
  end

  if _G.rename_hook and vim.is_callable(_G.rename_hook) then
    pcall(_G.rename_hook, oldpath, newpath)
  end

  clear_buffers(oldpath)
  reload_dirvish()
end

return M
