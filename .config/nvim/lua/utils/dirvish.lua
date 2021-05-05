local M = {}

local path_utils = require "utils/path"

local function get_path_under_cursor()
  return vim.fn.expand("<cfile>")
end

local function echo_err(msg)
  vim.cmd("echohl WarningMsg")
  vim.cmd(string.format("echomsg '%s'", msg))
  vim.cmd("echohl None")
end

local function reload_dirvish()
  vim.cmd("Dirvish %")
end

local function get_input(...)
  return vim.fn.trim(vim.fn.input(...))
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
    echo_err("Failed to delete " .. path)
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
  if vim.fn.isdirectory(path) == 1 then
    return vim.fn.fnamemodify(path, ":h:t")
  end

  return vim.fn.fnamemodify(path, ":t")
end

function M.rename()
  local old_path = get_path_under_cursor()
  local oldname = get_name(old_path)

  local newname = get_input("Rename: ", oldname)

  if not newname or newname == "" or newname == oldname then
    return
  end

  local new_path = vim.fn.expand("%") .. newname

  local clear_buffers = get_clear_buffers_function(old_path)
  local result = vim.fn.rename(old_path, new_path)

  if result ~= 0 then
    echo_err("Failed to rename")
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
      return vim.fn.expand("%") .. get_name(path)
    end,
    arglist
  )

  for _, path in ipairs(new_paths) do
    if vim.fn.isdirectory(path) == 1 or vim.fn.filereadable(path) == 1 then
      vim.cmd(("echoerr '%s'"):format(path .. " already exists!"))
      return
    end
  end

  for i = 1, #arglist do
    local old_path = arglist[i]
    local new_path = new_paths[i]
    local result = vim.fn.rename(old_path, new_path)

    if result ~= 0 then
      vim.cmd(string.format("echoerr 'Failed to rename %s to %s'", old_path, new_path))
      return
    end

    if result ~= 0 and _G.rename_hook and vim.is_callable(_G.rename_hook) then
      pcall(_G.rename_hook, old_path, new_path)
    end
  end

  reload_dirvish()
end

function M.copy()
  local arglist = vim.tbl_map(get_full_path, vim.fn.argv())

  if #arglist == 0 then
    return
  end

  local new_paths =
    vim.tbl_map(
    function(path)
      local name = get_name(path)
      local new_path = vim.fn.expand("%") .. name

      if not path_utils.path_exists(new_path) then
        return new_path
      end

      if vim.fn.getftype(path) == "file" then
        if vim.startswith(name, ".") then
          return new_path .. "_"
        end

        local _, dots_count = name:gsub("%.", "")

        local no_extensions = vim.fn.fnamemodify(new_path, string.rep(":r", dots_count))
        local extensions = "." .. vim.fn.fnamemodify(name, string.rep(":e", dots_count))
        return no_extensions .. "_" .. extensions
      end

      return new_path .. "_"
    end,
    arglist
  )

  for i = 1, #arglist do
    local old_path = arglist[i]
    local new_path = new_paths[i]
    local result = vim.loop.fs_copyfile(old_path, new_path)

    if not result then
      vim.cmd(string.format("echoerr 'Failed to copy %s'", old_path))
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
