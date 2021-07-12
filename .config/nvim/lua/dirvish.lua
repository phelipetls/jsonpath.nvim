local M = {}

local path_utils = require "path"

local function get_path_under_cursor()
  return vim.fn.getline(".")
end

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
    if vim.fn.bufexists(bufnr) == 1 then
      local buf_path = vim.api.nvim_buf_get_name(bufnr)

      if buf_path:find(deleted_dir, 1, true) then
        vim.cmd("silent! bd " .. bufnr)
      end
    end
  end
end

local function delete_file_buffer(fname)
  if vim.fn.buflisted(fname) == 1 then
    vim.cmd("silent! bd " .. vim.fn.bufnr(fname))
  end
end

local function get_clear_buffers_function(expr)
  if vim.fn.isdirectory(expr) == 1 then
    return delete_dir_buffers
  end

  return delete_file_buffer
end

local function delete_path(path)
  return vim.fn.delete(path, vim.fn.isdirectory(path) == 1 and "rf" or "")
end

function M.delete()
  local path = get_path_under_cursor()
  local option = vim.fn.confirm("Delete " .. path, "&Yes\n&No", 2)

  if option == 0 or option == 2 then
    return
  end

  local clear_buffers = get_clear_buffers_function(path)
  local result = delete_path(path)

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
  local old_path = get_path_under_cursor()
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

  if _G.rename_hook and vim.is_callable(_G.rename_hook) then
    pcall(_G.rename_hook, old_path, new_path)
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

local function get_full_path(fname)
  return vim.fn.fnamemodify(fname, ":p")
end

function M.move()
  local arglist = vim.tbl_map(get_full_path, vim.fn.argv())

  if #arglist == 0 then
    return
  end

  local new_paths =
    vim.tbl_map(
    function(path)
      return vim.fn.expand("%") .. get_basename(path)
    end,
    arglist
  )

  for _, path in ipairs(new_paths) do
    if vim.fn.isdirectory(path) == 1 or vim.fn.filereadable(path) == 1 then
      echoerr(path .. " already exists!")
      return
    end
  end

  for i = 1, #arglist do
    local old_path = arglist[i]
    local new_path = new_paths[i]
    local result = vim.fn.rename(old_path, new_path)

    if result ~= 0 then
      echoerr(string.format("Failed to rename %s to %s", old_path, new_path))
      return
    end

    if result ~= 0 and _G.rename_hook and vim.is_callable(_G.rename_hook) then
      pcall(_G.rename_hook, old_path, new_path)
    end
  end

  reload_dirvish()
end

local function get_non_conflicting_path(path)
  local basename = get_basename(path)
  local new_path = vim.fn.expand("%") .. basename

  if not path_utils.path_exists(new_path) then
    return new_path
  end

  if vim.fn.getftype(path) == "file" then
    if vim.startswith(basename, ".") then
      return new_path .. "_"
    end

    local _, dots_count = basename:gsub("%.", "")

    local no_extensions = vim.fn.fnamemodify(new_path, string.rep(":r", dots_count))
    local extensions = "." .. vim.fn.fnamemodify(basename, string.rep(":e", dots_count))
    return no_extensions .. "_" .. extensions
  end

  return new_path .. "_"
end

function M.copy()
  local arglist = vim.tbl_map(get_full_path, vim.fn.argv())

  if #arglist == 0 then
    return
  end

  local new_paths = vim.tbl_map(get_non_conflicting_path, arglist)

  for i = 1, #arglist do
    local old_path = arglist[i]
    local new_path = new_paths[i]

    local result

    if vim.fn.getftype(old_path) == "file" then
      result = vim.loop.fs_copyfile(old_path, new_path)
    else
      if vim.fn.executable("cp") then
        result = os.execute(string.format("cp -r %s %s", old_path, new_path))
      end
    end

    if not result or (type(result) == "number" and result > 0) then
      echoerr("Failed to copy " .. old_path)
      return
    end
  end

  reload_dirvish()
end

function M.clear_arglist()
  vim.cmd("%argdelete")
  vim.cmd("echomsg 'arglist: cleared'")
  reload_dirvish()
end

return M
