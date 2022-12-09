local dirvish = require("helpers.dirvish")

vim.keymap.set("n", "%", function()
  dirvish.create_file()
end, { silent = true, buffer = true, desc = "Create file" })

vim.keymap.set("n", "d", function()
  dirvish.create_dir()
end, { silent = true, nowait = true, buffer = true, desc = "Create directory" })

vim.keymap.set("n", "D", function()
  dirvish.delete()
end, { silent = true, buffer = true, desc = "Delete file/directory" })

vim.keymap.set("n", "R", function()
  dirvish.rename()
end, { silent = true, buffer = true, desc = "Rename" })

vim.keymap.set("n", "X", function()
  dirvish.clear_arglist()
end, { silent = true, buffer = true, desc = "Clear arglist" })
