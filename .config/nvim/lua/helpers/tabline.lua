local M = {}

local function get_tablabel(bufname, bufnr)
  if not bufname or bufname == "" then
    return "[No Name]"
  end

  local basename = vim.fs.basename(bufname)

  if vim.startswith(basename, "index") then
    local directory = vim.fs.basename(vim.fs.dirname(bufname))
    return directory .. "/" .. basename
  end

  local buffiletype = vim.fn.getbufvar(bufnr, "&filetype")

  if buffiletype == "dirvish" then
    return vim.fn.fnamemodify(bufname, ":p:.")
  end

  if buffiletype == "fugitive" then
    return "fugitive"
  end

  return basename
end

M.get = function()
  local tabline = {}

  for tab = 1, vim.fn.tabpagenr("$") do
    table.insert(tabline, "%" .. tab .. "T")

    local is_selected = tab == vim.fn.tabpagenr()
    local tabline_hl = is_selected and "TabLineSel" or "TabLine"
    table.insert(tabline, "%#" .. tabline_hl .. "#")
    table.insert(tabline, "  ")

    local tabwinnr = vim.fn.tabpagewinnr(tab)
    local tabbuflist = vim.fn.tabpagebuflist(tab)
    local tabbufnr = tabbuflist[tabwinnr]
    local tabbufname = vim.fn.bufname(tabbufnr)
    table.insert(tabline, get_tablabel(tabbufname, tabbufnr))

    table.insert(tabline, "  ")
  end

  table.insert(tabline, "%#TabLineFill#")

  return table.concat(tabline, "")
end

return M
