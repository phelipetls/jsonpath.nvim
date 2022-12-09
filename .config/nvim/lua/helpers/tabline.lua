local M = {}

local get_tablabel = function(tabbufnr)
  local tabbufname = vim.fn.bufname(tabbufnr)

  if tabbufname == "" then
    return "[No Name]"
  end

  local basename = vim.fs.basename(tabbufname)
  local dirname = vim.fs.dirname(tabbufname)

  if vim.fn.getbufvar(tabbufnr, "&filetype") == "dirvish" then
    return vim.fn.fnamemodify(tabbufname, ":p")
  end

  if vim.startswith(tabbufname, "fugitive:///") then
    local fugitive_commitfile = vim.fn.FugitiveParse(tabbufname)[1]

    if fugitive_commitfile == "" then
      return "fugitive"
    end

    if fugitive_commitfile == ":" then
      return "fugitive-summary"
    end
  end

  if basename:match("^index%.+$") then
    return dirname .. "/" .. basename
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
    local tablabel = get_tablabel(tabbufnr)
    table.insert(tabline, tablabel)

    table.insert(tabline, "  ")
  end

  table.insert(tabline, "%#TabLineFill#")

  return table.concat(tabline, "")
end

return M
