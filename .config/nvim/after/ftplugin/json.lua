vim.bo.formatprg = "jq ."

vim.wo.winbar = "%{%v:lua.require'jsonpath'.get()%}"

vim.keymap.set("n", "y<C-p>", function()
  vim.fn.setreg("+", require("jsonpath").get())
end, { desc = "copy json path", buffer = true })
