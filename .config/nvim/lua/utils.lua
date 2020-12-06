local M = {}

local function get_windows_with_same_buffer(bufnr, tabnr)
  local all_windows = vim.fn.getwininfo()

  local windows =
    vim.tbl_filter(
    function(window)
      return window.bufnr == bufnr and window.tabnr == tabnr
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
  local tabnr = vim.fn.tabpagenr()
  local windows = get_windows_with_same_buffer(get_bufnr(), tabnr)
  for _, winnr in ipairs(windows) do
    vim.api.nvim_command(string.format("%dwincmd w", winnr))
    vim.api.nvim_command(cmd)
  end
  go_to_window(winnr)
end

local function get_closest_qf_item(item, col, line)
  return item.lnum > line and item.col > cursor
end

function M.lafter()
  local loclist = vim.fn.getloclist(0)
  local col = vim.fn.col(".")
  local line = vim.fn.line(".")
  local next_list_item =
    vim.tbl_filter(
    function(item)
      get_closest_qf_item(item, col, line)
    end,
    loclist
  )
end

return M
