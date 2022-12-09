vim.opt_local.formatprg = "jq ."

vim.opt_local.winbar = "%{%v:lua.require'jsonpath'.get()%}"

vim.keymap.set("n", "y<C-p>", function()
  vim.fn.setreg("+", require("jsonpath").get())
end, { desc = "copy json path", buffer = true })
