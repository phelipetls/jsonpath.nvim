vim.cmd("runtime! ftplugin/javascript.lua")

vim.keymap.set("n", "<F5>", "<cmd>w !deno<CR>", { buffer = true, noremap = true })
