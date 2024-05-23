local M = {}

_G.get_fugitive_statusline = function()
  local raw = vim.fn["FugitiveStatusline"]()

  if raw == "" then
    return ""
  end

  -- extract branch from [Git(branch)] pattern
  local branch = raw:match("%(.+%)"):sub(2, -2)

  -- truncate branch name
  local MAX_LENGTH = 25
  local truncated_branch = branch:sub(1, MAX_LENGTH)
  if branch ~= truncated_branch then
    truncated_branch = truncated_branch .. "…"
  end

  local result = string.gsub(raw, vim.pesc(branch), truncated_branch, 1)
  return string.format("%s", result)
end

local grouped = function(s)
  return "%(" .. s .. "%)"
end

local quickfix_statusline = " %q%{exists('w:quickfix_title')? ' '.w:quickfix_title : ''}%= [%l/%L] "
M.quickfix_statusline = quickfix_statusline

M.get = function(opts)
  if vim.bo.filetype == "qf" then
    return quickfix_statusline
  end

  local active = vim.g.statusline_winid == vim.fn.win_getid()

  local statusline = {}

  table.insert(statusline, grouped(" %f"))
  table.insert(statusline, grouped(" %m"))

  if active then
    table.insert(statusline, "%=")
    table.insert(statusline, grouped(" %{v:lua.get_fugitive_statusline()} |"))
    table.insert(statusline, grouped(" %l:%L "))
  end

  return table.concat(statusline, "")
end

return M
