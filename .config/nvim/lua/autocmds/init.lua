local global_autocmds_augroup = vim.api.nvim_create_augroup("GlobalAutocmds", {})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = global_autocmds_augroup,
  pattern = { "*" },
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Don't autocomment on newline",
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  group = global_autocmds_augroup,
  pattern = { "*" },
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") and not vim.bo.filetype:match("git") then
      vim.cmd.normal('g`"')
    end
  end,
  desc = "Recover last cursor position when opening a file, except on git commits etc.",
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = global_autocmds_augroup,
  pattern = { "*" },
  command = "wincmd =",
  desc = "Automatically resize splits when Neovim is resized",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = global_autocmds_augroup,
  pattern = {
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "sh",
    "yaml",
    "vim",
    "lua",
    "json",
    "html",
    "css",
  },
  callback = function()
    vim.o.expandtab = true
    vim.o.shiftwidth = 2
    vim.o.softtabstop = 2
  end,
  desc = "Set up 2-space indentation for some file types",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = global_autocmds_augroup,
  pattern = {
    "python",
  },
  callback = function()
    vim.o.expandtab = true
    vim.o.shiftwidth = 4
    vim.o.softtabstop = 4
  end,
  desc = "Set up 4-space indentation for some file types",
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = global_autocmds_augroup,
  pattern = { "*" },
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local basename = vim.fs.basename(bufname)
    vim.fn.setreg("f", basename)
  end,
  desc = "Put the current file name under the f register",
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = global_autocmds_augroup,
  pattern = { "*" },
  callback = function()
    local path = vim.fn.expand("<afile>:p")

    if path:match("^fugitive://") then
      return
    end

    vim.fn.mkdir(vim.fs.dirname(path), "p")
  end,
  desc = "create intermediate directories automatically before saving file",
})

vim.api.nvim_create_autocmd({ "VimResume", "FocusGained" }, {
  group = global_autocmds_augroup,
  pattern = { "*" },
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd.checktime()
    end
  end,
  desc = "Automatically update file when Neovim resumes",
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = global_autocmds_augroup,
  pattern = { "*" },
  callback = function()
    vim.highlight.on_yank({ higroup = "Search", on_visual = false })
  end,
  desc = "Highlight yanked region",
})

local open_file_with_f5_autocmd = vim.api.nvim_create_augroup("OpenFileWithF5", { clear = true })

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = open_file_with_f5_autocmd,
  pattern = { "html", "dirvish", "svg" },
  callback = function()
    vim.keymap.set("n", "<F5>", function()
      require("helpers.os").open(vim.fn.expand("%:p"))
    end, { desc = "Open current file with the operating system" })
  end,
})

local quickfix_augroup = vim.api.nvim_create_augroup("Quickfix", { clear = true })

vim.api.nvim_create_autocmd({ "QuickFixCmdPost" }, {
  group = quickfix_augroup,
  pattern = { "*" },
  callback = function()
    require("helpers.qflist").open()
  end,
  desc = "Open Quickfix list automatically",
})

vim.api.nvim_create_autocmd({ "WinEnter" }, {
  group = quickfix_augroup,
  pattern = { "*" },
  callback = function()
    if vim.fn.winnr("$") == 1 and vim.o.buftype == "quickfix" then
      vim.cmd.quit()
    end
  end,
  desc = "Close quickfix list if it's the last window",
})
