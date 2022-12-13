local window_is_full_width = function()
  return vim.fn.winwidth(0) == vim.o.columns
end

local fugitivestatusline = function()
  local fugitive = vim.fn["FugitiveStatusline"]()

  local file_revision = string.match(fugitive, "Git:(.+)%(")
  local checked_out_branch = string.match(fugitive, "Git%((.+)%)")

  if file_revision == "0" then
    return "index"
  end

  return file_revision or checked_out_branch or ""
end

local filename = function()
  local full_path = vim.fn.expand("%:p")

  if path == "" then
    return "[No Name]"
  end

  local fname = vim.fn.expand("%:t")

  if fname:match("^fugitive://") then
    local fugitive_commitfile = unpack(vim.fn["FugitiveParse"](path))

    if not fugitive_commitfile then
      return "fugitive"
    end

    if fugitive_commitfile == ":" then
      return "fugitive-summary"
    end

    return fugitive_commitfile
  end

  if fname:match("^index%.%a+$") then
    local dir = vim.fn.expand("%:p:h:t")
    return dir .. "/" .. fname
  end

  return window_is_full_width() and path or fname
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
        cond = window_is_full_width,
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
    lualine_b = {},
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
