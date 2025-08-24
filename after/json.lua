if require("jsonpath").opts.show_on_winbar then
  vim.wo.winbar = "%{%v:lua.require'jsonpath'.get()%}"
end
