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
  local fullpath = vim.fn.expand("%:p")
  local fname = vim.fn.expand("%:t")
  local dir = vim.fn.expand("%:p:h:t")

  if fullpath == "" then
    return "[No Name]"
  end

  if fname:match("^fugitive://") then
    local fugitive_commitfile = unpack(vim.fn["FugitiveParse"](fullpath))

    if not fugitive_commitfile then
      return "fugitive"
    end

    if fugitive_commitfile == ":" then
      return "fugitive-summary"
    end

    return fugitive_commitfile
  end

  if fname:match("^index%.%a+$") then
    return dir .. "/" .. fname
  end

  return vim.fn.expand("%")
end

local modified = function()
  return "[+]"
end

local readonly = function()
  return "[-]"
end

local only_one_window_visible = function()
  return vim.fn.winwidth(0) == vim.o.columns
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
        cond = only_one_window_visible,
      },
      {
        "g:coc_status",
        cond = only_one_window_visible,
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
        color = { fg = vim.fn["highlight#get_hlgroup_params"]("Debug").fg },
        cond = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end
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
        end
      },
    },
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
