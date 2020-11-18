local M = {}

local function get_windows_with_same_buffer(bufnr)
  local all_windows = vim.fn.getwininfo()

  local windows =
    vim.tbl_filter(
    function(window)
      return window.bufnr == bufnr
    end,
    all_windows
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
  return vim.api.nvim_win_get_buf(vim.fn.nvim_get_current_win())
end

function M.same_buffer_windo(cmd)
  local winnr = vim.fn.winnr()
  local windows = get_windows_with_same_buffer(get_bufnr())
  for _, winnr in ipairs(windows) do
    vim.api.nvim_command(string.format("%dwincmd w", winnr))
    vim.api.nvim_command(cmd)
  end
  go_to_window(winnr)
end

return M
