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

local function inside_current_tab(window)
  return window.tabnr == vim.fn.tabpagenr()
end

local function is_quickfix(window)
  return inside_current_tab(window) and window.quickfix == 1 and window.loclist == 0
end

local function is_loclist(window)
  return inside_current_tab(window) and window.quickfix == 1 and window.loclist == 1
end

function M.quickfix_is_visible()
  local quickfix_windows = filter_windows(is_quickfix)
  return #quickfix_windows > 0
end

function M.loclist_is_visible()
  local loclist_windows = filter_windows(is_loclist)
  return #loclist_windows > 0
end

return M
