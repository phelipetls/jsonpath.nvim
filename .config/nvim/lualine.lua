local fugitivestatusline = function()
  local fugitive = vim.fn["FugitiveStatusline"]()

  local _, _, revision = string.find(fugitive, "%[Git:(.+)%(")
  local _, _, branch = string.find(fugitive, "%[Git%((.+)%)")

  if revision == "0" then
    return "index"
  end

  return revision or branch or ""
end

local filename = {
  function()
    local fullpath = vim.fn.expand("%:p")
    local fname = vim.fn.expand("%:t")

    fname = fname ~= "" and fname or "[No Name]"

    if fullpath:find("^fugitive://") then
      local commit = vim.fn.FugitiveStatusline():match("Git:(%d+)")

      if commit and commit ~= "" then
        local label = commit

        if commit == "0" then
          label = "index"
        end

        return string.format("%s:%s", label, fname)
      end
    end

    return fname
  end,
  padding = { left = 1, right = 1 },
}

local modified = {
  function()
    return "[+]"
  end,
  cond = function()
    return vim.bo.modified
  end,
  padding = { left = 0, right = 1 },
}

local readonly = {
  function()
    return "[-]"
  end,
  cond = function()
    return not vim.bo.modifiable or vim.bo.readonly
  end,
  padding = { left = 0, right = 1 },
}

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
      filename,
      modified,
      readonly,
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
      filename,
      modified,
      readonly,
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
