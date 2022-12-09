vim.b.coc_root_patterns = { "package.json", ".git" }

if vim.fn.bufname():match("%.min%.js$") then
  vim.b.coc_enabled = 0
end

vim.opt_local.path:append({ "node_modules", "cypress/fixtures" })
vim.opt_local.path:append(require("helpers.tsconfig").get_tsconfig_include())

local fname = vim.fn.expand("%:p:t")
if fname:match("test%..+$") == 1 then
  vim.cmd("compiler jest")
elseif not vim.tbl_isempty(vim.fs.find({ "tsconfig.json", "jsconfig.json" }, { upward = true })) then
  vim.cmd("compiler tsc")
elseif vim.fn.executable("eslint_d") == 1 then
  vim.cmd("compiler eslint_d")
elseif vim.fn.executable("eslint") == 1 then
  vim.cmd("compiler eslint")
end

vim.keymap.set("n", "<F5>", "<cmd>w !node<CR>", { buffer = true })
vim.opt_local.formatprg = "npx prettier --stdin-filepath %"

vim.b[string.format("surround_%s", vim.fn.char2nr("c"))] = "console.log(\r)"
vim.b[string.format("surround_%s", vim.fn.char2nr("e"))] = "${\r}"

vim.keymap.set("n", "[<C-c>", "zyiwOconsole.log(z)<Esc>", { buffer = true, noremap = true })
vim.keymap.set("n", "]<C-c>", "zyiwoconsole.log(z)<Esc>", { buffer = true, noremap = true })

vim.cmd("inoreabbrev <buffer><silent> clog console.log()<Left><C-R>=utils#eatchar('\\s')<CR>")
vim.cmd("inoreabbrev <buffer> consoel console")
vim.cmd("inoreabbrev <buffer> lenght length")
vim.cmd("inoreabbrev <buffer> edf export default function")
vim.cmd("inoreabbrev <buffer> improt import")
vim.cmd("inoreabbrev <buffer> Obejct Object")
vim.cmd("inoreabbrev <buffer> entires entries")
vim.cmd("inoreabbrev <buffer> cosnt const")
vim.cmd("inoreabbrev <buffer> docuemnt document")

vim.opt_local.isfname:append({ "@-@" })
vim.opt_local.suffixesadd = {
  ".js",
  ".jsx",
  ".ts",
  ".tsx",
  ".d.ts",
  ".vue",
  "/package.json",
}

_G.javascript_node_find = function(target)
  return require("helpers.tsconfig").includeexpr(target)
end

vim.opt_local.includeexpr = 'v:lua.javascript_node_find(v:fname)'

local javascript_autocmds = vim.api.nvim_create_augroup("JavaScriptAutocmds", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = javascript_autocmds,
  buffer = 0,
  callback = function()
    require("helpers.template_string_converter").convert()
  end,
  desc = "Automatically convert string to template string if there is an interpolation character",
})
