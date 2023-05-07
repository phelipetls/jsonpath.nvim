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
  return string.format("%s | ", result)
end

M.get = function(opts)
  local statusline = {}

  table.insert(statusline, " ")
  table.insert(statusline, "%f")
  table.insert(statusline, " ")
  table.insert(statusline, "%m")

  if opts.active then
    table.insert(statusline, "%=")
    table.insert(statusline, "%{v:lua.get_fugitive_statusline()}")
    table.insert(statusline, "%l:%L")
    table.insert(statusline, " ")
  end

  return table.concat(statusline, "")
end

return M
