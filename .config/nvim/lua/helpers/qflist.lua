local M = {}

M.open = function()
  vim.cmd("botright cwindow 5")

  if vim.bo.buftype == "quickfix" then
    vim.cmd("wincmd p")
  end
end

local is_qflist_open_in_current_tab = function()
  local windows = vim.fn.getwininfo()

  local current_tabnr = vim.fn.tabpagenr()
  local windows_in_current_tab = vim.tbl_filter(function(win)
    return win.tabnr == current_tabnr
  end, windows)

  local qflist_in_current_tab = vim.tbl_filter(function(win)
    return win.quickfix == 1 and win.loclist == 0
  end, windows_in_current_tab)

  return #qflist_in_current_tab > 0
end

M.toggle = function()
  if is_qflist_open_in_current_tab() then
    vim.cmd("cclose")
    return
  end

  M.open()
end

M.next = function()
  local ok, _ = pcall(vim.cmd, "cnext")

  if not ok then
    ok, _ = pcall(vim.cmd, "cfirst")
  end

  if ok then
    vim.cmd("normal! zz")
  end
end

M.prev = function()
  local ok, _ = pcall(vim.cmd, "cprev")

  if not ok then
    ok, _ = pcall(vim.cmd, "clast")
  end

  if ok then
    vim.cmd("normal! zz")
  end
end

return M
