local function fugitive()
  local raw = vim.fn["FugitiveStatusline"]()

  -- extract branch from [Git(branch)] pattern
  local branch = raw:match("%(.+%)"):sub(2, -2)

  -- truncate branch name
  local MAX_LENGTH = 25
  local truncated_branch = branch:sub(1, MAX_LENGTH)
  if branch ~= truncated_branch then
    truncated_branch = truncated_branch .. "…"
  end

  return string.gsub(raw, branch, truncated_branch, 1)
end

require("lualine").setup({
  options = {
    icons_enabled = false,
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = {
      "mode",
    },
    lualine_b = {
      fugitive,
    },
    lualine_c = {
      {
        "%f",
        type = "stl",
      },
      {
        "%m",
        type = "stl",
      },
    },
    lualine_x = {},
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
    lualine_c = {
      {
        "%f",
        type = "stl",
      },
      {
        "%m",
        type = "stl",
      },
    },
    lualine_x = {},
    lualine_y = {},
  },
  extensions = {
    "fugitive",
    {
      sections = {
        lualine_a = {
          {
            "%q",
            type = "stl",
          },
        },
        lualine_b = {
          {
            "w:quickfix_title",
          },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
          {
            "%l/%L",
            type = "stl",
          },
        },
      },
      filetypes = { "qf" },
    },
    {
      sections = {
        lualine_a = {
          function()
            return string.format("%d args", #vim.fn.argv())
          end,
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
