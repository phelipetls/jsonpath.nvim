local fugitivestatusline = function()
  local fugitive = vim.fn["FugitiveStatusline"]()

  local _, _, revision = string.find(fugitive, "%[Git:(.+)%(")
  local _, _, branch = string.find(fugitive, "%[Git%((.+)%)")

  if revision == "0" then
    return "index"
  end

  return revision or branch or ""
end

local filename = function()
  local fullpath = vim.fn.expand("%:p")
  local fname = vim.fn.expand("%:t")

  fname = fname ~= "" and fname or "[No Name]"

  if fullpath:find("^fugitive://") then
    local matches = vim.fn.matchlist(
      fullpath,
      [[\c^fugitive:\%(//\)\=\(.\{-\}\)\%(//\|::\)\(\x\{40,\}\|[0-3]\)\(/.*\)\=$]]
    )
    local revision = matches[3]
    if revision and revision ~= "" then
      local revisionlabel = revision == "0" and "index" or string.sub(revision, 0, 7)
      fname = string.format("%s:%s", revisionlabel, fname)
    end
  end

  local modified = vim.bo.modified and "[+]" or ""
  local readonly = (not vim.bo.modifiable or vim.bo.readonly) and "[-]" or ""

  return string.format("%s %s %s", fname, modified, readonly)
end

package.path = package.path .. ";" .. table.concat({ os.getenv("HOME"), ".cache", "wal", "?.lua" }, "/")
local wal_colors = require("colors")

require("lualine").setup({
  options = {
    icons_enabled = false,
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = {
      {
        "mode",
      },
    },
    lualine_b = {
      {
        fugitivestatusline,
        icon = { "" },
        cond = function()
          return vim.fn.winwidth(0) == vim.o.columns
        end,
      },
      "g:coc_status",
      "g:async_make_status",
    },
    lualine_c = {
      {
        filename,
      },
    },
    lualine_x = { "diagnostics", "fileformat", "filetype" },
    lualine_y = {},
    lualine_z = {
      {
        "%l:%L",
        type = "stl",
      },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { filename },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      "filetype",
    },
  },
  extensions = {
    "quickfix",
    "fugitive",
    {
      sections = {
        lualine_a = {
          {
            function()
              return string.format("%d args", #vim.fn.argv())
            end,
          },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      filetypes = { "dirvish" },
    },
  },
})
