vim.keymap.set("x", "is", "<Plug>(textobj-sandwich-query-i)", {})
vim.keymap.set("x", "as", "<Plug>(textobj-sandwich-query-a)", {})
vim.keymap.set("o", "is", "<Plug>(textobj-sandwich-query-i)", {})
vim.keymap.set("o", "as", "<Plug>(textobj-sandwich-query-a)", {})

vim.keymap.set("x", "iss", "<Plug>(textobj-sandwich-auto-i)", {})
vim.keymap.set("x", "ass", "<Plug>(textobj-sandwich-auto-a)", {})
vim.keymap.set("o", "iss", "<Plug>(textobj-sandwich-auto-i)", {})
vim.keymap.set("o", "ass", "<Plug>(textobj-sandwich-auto-a)", {})

vim.cmd("runtime macros/sandwich/keymap/surround.vim")

vim.g["sandwich#recipes"] = vim.tbl_extend(vim.g["sandwich#recipes"], {
  {
    buns = { "{ ", " }" },
    nesting = 1,
    match_syntax = 1,
    kind = { "add", "replace" },
    action = { "add" },
    input = { "{" },
  },
  {
    buns = { "[ ", " ]" },
    nesting = 1,
    match_syntax = 1,
    kind = { "add", "replace" },
    action = { "add" },
    input = { "[" },
  },
  {
    buns = { "( ", " )" },
    nesting = 1,
    match_syntax = 1,
    kind = { "add", "replace" },
    action = { "add" },
    input = { "(" },
  },
  {
    buns = { "{s*", "s*}" },
    nesting = 1,
    regex = 1,
    match_syntax = 1,
    kind = { "delete", "replace", "textobj" },
    action = { "delete" },
    input = { "{" },
  },
  {
    buns = { "[s*", "s*]" },
    nesting = 1,
    regex = 1,
    match_syntax = 1,
    kind = { "delete", "replace", "textobj" },
    action = { "delete" },
    input = { "[" },
  },
  {
    buns = { "(s*", "s*)" },
    nesting = 1,
    regex = 1,
    match_syntax = 1,
    kind = { "delete", "replace", "textobj" },
    action = { "delete" },
    input = { "(" },
  },
})
