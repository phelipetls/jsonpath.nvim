local M = {}

local function should_show_dirname(basename)
  local unhelpful_basenames = { "index", "style", "styles" }
  local basename_without_extension = vim.fn.fnamemodify(basename, ':r')
  return vim.tbl_contains(unhelpful_basenames, basename_without_extension)
end

_G.get_tablabel = function(tabnr)
  local winnr = vim.fn.tabpagewinnr(tabnr)
  local buflist = vim.fn.tabpagebuflist(tabnr)
  local bufnr = buflist[winnr]

  local bufname = vim.api.nvim_buf_get_name(bufnr)

  if not bufname or bufname == "" then
    return "[No Name]"
  end

  local basename = vim.fs.basename(bufname)

  if should_show_dirname(basename) then
    local dirname = vim.fs.basename(vim.fs.dirname(bufname))
    return dirname .. "/" .. basename
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

local function grouped(s)
  return "%(" .. s .. "%)"
end

M.get = function()
  local tabline = {}

  for tab = 1, vim.fn.tabpagenr("$") do
    table.insert(tabline, "%" .. tab .. "T")

    local is_selected = tab == vim.fn.tabpagenr()
    table.insert(tabline, "%#" .. (is_selected and "TabLineSel" or "TabLine") .. "#")

    table.insert(tabline, " ")
    table.insert(tabline, "%{%v:lua.get_tablabel(" .. tab .. ")%}")
    table.insert(tabline, " ")
  end

  table.insert(tabline, "%#TabLineFill#")
  table.insert(tabline, "%=")
  table.insert(tabline, grouped("%{coc#status()} "))

  return table.concat(tabline, "")
end

return M
