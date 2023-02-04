local M = {}

M.open = function()
  vim.cmd.lwindow({ args = { "5" }, mods = { split = "botright" } })

  if vim.bo.buftype == "quickfix" then
    vim.cmd.wincmd("p")
  end
end

local function is_loclist_open_in_current_tab()
  local windows = vim.fn.getwininfo()

  local current_tabnr = vim.fn.tabpagenr()
  local windows_in_current_tab = vim.tbl_filter(function(win)
    return win.tabnr == current_tabnr
  end, windows)

  local loclist_in_current_tab = vim.tbl_filter(function(win)
    return win.quickfix == 1 and win.loclist == 1
  end, windows_in_current_tab)

  return #loclist_in_current_tab > 0
end

M.toggle = function()
  if is_loclist_open_in_current_tab() then
    vim.cmd.cclose()
    return
  end

  M.open()
end

M.next = function()
  local ok, _ = pcall(vim.cmd, "lnext")

  if not ok then
    ok, _ = pcall(vim.cmd, "cfirst")
  end

  if ok then
    vim.cmd("normal! zz")
  end
end

M.prev = function()
  local ok, _ = pcall(vim.cmd, "lprev")

  if not ok then
    ok, _ = pcall(vim.cmd, "llast")
  end

  if ok then
    vim.cmd("normal! zz")
  end
end

return M
