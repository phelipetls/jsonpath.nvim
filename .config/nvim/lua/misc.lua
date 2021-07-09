local M = {}

local function filter_windows(fn)
  return vim.tbl_filter(fn, vim.fn.getwininfo())
end

local function get_windows_with_same_buffer(bufnr, tabnr)
  local windows =
    filter_windows(
    function(window)
      return window.bufnr == bufnr and window.tabnr == tabnr
    end
  )

  return vim.tbl_map(
    function(window)
      return window.winnr
    end,
    windows
  )
end

local function go_to_window(winnr)
  vim.api.nvim_command(string.format("%dwincmd w", winnr))
end

local function get_bufnr()
  return vim.api.nvim_win_get_buf(vim.api.nvim_get_current_win())
end

function M.same_buffer_windo(cmd)
  local initial_winnr = vim.fn.winnr()
  local tabnr = vim.fn.tabpagenr()
  local windows = get_windows_with_same_buffer(get_bufnr(), tabnr)
  for _, winnr in ipairs(windows) do
    vim.api.nvim_command(string.format("%dwincmd w", winnr))
    vim.api.nvim_command(cmd)
  end
  go_to_window(initial_winnr)
end

function M.once(fn)
  local value
  return function(...)
    if not value then
      value = fn(...)
    end
    return value
  end
end

return M
