local M = {}

local function show_error(error_message)
  vim.cmd.echohl("ErrorMsg")
  vim.cmd.echo(string.format("'%s'", error_message))
  vim.cmd.echohl("None")
end

local function get_open_command()
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

  if vim.fn.executable(open_command) ~= 1 then
    show_error(string.format("The program %s is not executable", open_command))
    return
  end

  local cmd = string.format("%s %s", open_command, vim.fn.shellescape(fname))

  vim.fn.jobstart(cmd, {
    on_exit = function(_, status)
      if status > 0 then
        if vim.fn.filereadable(fname) ~= 1 or vim.fn.isdirectory(fname) ~= 1 then
          show_error(string.format("Could not open %s because it does not exist", fname))
          return
        end

        show_error(string.format("Failed to open %s with %s", fname, open_command))
      end
    end,
  })
end

local function is_normal_mode()
  return vim.fn.mode() == "n"
end

M.open_under_cursor = function()
  local fname = vim.fn.expand("<cfile>")

  if not is_normal_mode() then
    fname = vim.fn["helpers#get_visual_selection"]()
  end

  M.open(fname)
end

return M
