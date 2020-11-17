local M = {}

local function table_has_empty_values_only(tbl)
  return #vim.tbl_filter(function(v) return v == '' end, tbl) == #tbl
end

local function get_windows_with_same_buffer(bufnr)
  local all_windows = vim.fn.getwininfo()

  local windows = vim.tbl_filter(function(window)
    return window.bufnr == bufnr
  end, all_windows)

  return vim.tbl_map(function(window) return window.winnr end, windows)
end

local function save_views(windows)
  for _, winnr in ipairs(windows) do
    vim.api.nvim_command(string.format("%dwindo let w:view = winsaveview()", winnr))
  end
end

local function restore_views(windows)
  for _, winnr in ipairs(windows) do
    vim.api.nvim_command(string.format("%dwindo call winrestview(w:view)", winnr))
  end
end

local function go_to_window(winnr)
  vim.api.nvim_command(string.format("%dwincmd w", winnr))
end

function M.format(start_line, end_line)
  local formatprg = vim.bo.formatprg
  local window = vim.fn.nvim_get_current_win()
  local winnr = vim.fn.winnr()
  local bufnr = vim.api.nvim_win_get_buf(window)
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  local windows = get_windows_with_same_buffer(bufnr)
  save_views(windows)
  go_to_window(winnr)

  local formatter = string.format("%s %s", formatprg, bufname)

  local function on_event(job_id, data, event)
    if event == "stdout" then
      if table_has_empty_values_only(data) then return end
      vim.api.nvim_buf_set_lines(bufnr, start_line, end_line, true, data)
    end

    if event == "stderr" then
      if table_has_empty_values_only(data) then return end
      local program = vim.split(formatprg, ' ')[1]
      vim.api.nvim_command(string.format("echoerr '%s failed while formatting.'", program))
    end

    if event == "exit" then
      restore_views(windows)
      go_to_window(winnr)
    end
  end

  local output =
    vim.fn.jobstart(
    formatter,
    {
      on_stdout = on_event,
      on_stderr = on_event,
      on_exit = on_event,
      stdout_buffered = true,
      stderr_buffered = true
    }
  )
end

return M
