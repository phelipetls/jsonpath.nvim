local fugitivestatusline = function()
  local fugitive = vim.fn["FugitiveStatusline"]()

  local _, _, revision = string.find(fugitive, "%[Git:(.+)%(")
  local _, _, branch = string.find(fugitive, "%[Git%((.+)%)")

  if revision == "0" then
    return "worktree"
  end

  return revision or branch or ""
end

require("lualine").setup({
  options = {
    theme = "pywal",
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(str)
          return " "
        end,
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
        "filename",
        path = 0,
        symbols = {
          modified = " [+]",
          readonly = " [-]",
        },
      },
    },
    lualine_x = { "fileformat", "filetype" },
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
    lualine_c = { "filename" },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      "filetype",
      "location",
    },
  },
  tabline = {
    lualine_a = {
      {
        "tabs",
        max_length = vim.o.columns,
        mode = 2,
      },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  extensions = {
    "quickfix",
    "fugitive",
    {
      sections = {
        lualine_a = {
          {
            function()
              return #vim.fn.argv()
            end,
            fmt = function(args)
              return string.format("%d args", args)
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
