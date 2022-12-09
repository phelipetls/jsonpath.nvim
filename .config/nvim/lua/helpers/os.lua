local M = {}

local show_error = function(error_message)
  vim.cmd("echohl ErrorMsg")
  vim.cmd(string.format("echo '%s'", error_message))
  vim.cmd("echohl None")
end

local get_open_command = function()
  local open_command = ""

  if vim.fn.has("mac") == 1 then
    open_command = "open"
  elseif vim.fn.has("wsl") == 1 then
    open_command = "wslview"
  elseif vim.fn.has("unix") == 1 then
    open_command = "xdg-open"
  end

  if open_command == "" then
    show_error("Could not determine a command to open file")
    return ""
  end

  return open_command
end

M.open = function(fname)
  local open_command = get_open_command()

  if vim.fn.executable(open_command) == 0 then
    show_error(string.format("The program %s is not executable", open_command))
    return
  end

  vim.fn.jobstart(string.format("%s %s", open_command, vim.fn.shellescape(fname), {
    on_exit = function(_, status)
      if status > 0 then
        show_error(string.format("Failed to open %s with %s", fname, open_command))
      end
    end,
  }))
end

M.open_under_cursor = function()
  local fname = vim.fn.expand("<cfile>")

  if vim.fn.mode() ~= "n" then
    fname = vim.fn["utils#get_visual_selection"]()
  end

  M.open(fname)
end

return M
