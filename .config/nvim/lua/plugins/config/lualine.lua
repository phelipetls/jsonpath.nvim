local window_is_full_width = function()
  return vim.fn.winwidth(0) == vim.o.columns
end

local fugitivestatusline = function()
  local fugitive = vim.fn["FugitiveStatusline"]()

  local revision = string.match(fugitive, "Git:(.+)%(")
  local checked_out_branch = string.match(fugitive, "Git%((.+)%)")

  if revision == "0" then
    return "index"
  end

  return revision or checked_out_branch or ""
end

local filename = function()
  local bufname = vim.api.nvim_buf_get_name(0)

  if vim.startswith(bufname, "fugitive:///") then
    local fugitive_parsed = vim.fn["FugitiveParse"](bufname)[1]

    if fugitive_parsed == "" then
      return "fugitive"
    end

    if fugitive_parsed == ":" then
      return "fugitive-summary"
    end

    bufname = vim.split(fugitive_parsed, ":", { trimempty = true })[2]
  end

  return vim.fn.fnamemodify(bufname, ":.")
end

local modified = function()
  return "[+]"
end

local readonly = function()
  return "[-]"
end

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
      },
      {
        "g:coc_status",
        cond = window_is_full_width,
      },
    },
    lualine_c = {
      {
        filename,
      },
      {
        modified,
        cond = function()
          return vim.bo.modified
        end,
        padding = { left = 0, right = 1 },
      },
      {
        readonly,
        padding = { left = 0, right = 1 },
        cond = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end,
      },
    },
    lualine_x = {
      {
        "diagnostics",
      },
      {
        "fileformat",
        cond = window_is_full_width,
      },
      {
        "filetype",
      },
    },
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
    lualine_b = {
      {
        fugitivestatusline,
      },
    },
    lualine_c = {
      {
        filename,
      },
      {
        modified,
        cond = function()
          return vim.bo.modified
        end,
        padding = { left = 0, right = 1 },
      },
      {
        readonly,
        padding = { left = 0, right = 1 },
        cond = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end,
      },
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      "filetype",
    },
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
