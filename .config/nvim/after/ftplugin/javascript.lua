vim.b.coc_root_patterns = { "package.json", ".git" }

if vim.fn.bufname():match("%.min%.js$") then
  vim.b.coc_enabled = 0
end

local fname = vim.fn.expand("%:p:t")
if fname:match("test%..+$") == 1 then
  vim.cmd.compiler("jest")
elseif not vim.tbl_isempty(vim.fs.find({ "tsconfig.json", "jsconfig.json" }, { upward = true })) then
  vim.cmd.compiler("tsc")
elseif vim.fn.executable("eslint_d") == 1 then
  vim.cmd.compiler("eslint_d")
elseif vim.fn.executable("eslint") == 1 then
  vim.cmd.compiler("eslint")
end

vim.keymap.set("n", "<F5>", "<cmd>w !node<CR>", { buffer = true })
vim.opt_local.formatprg = "npx prettier --stdin-filepath %"

vim.b[string.format("surround_%s", vim.fn.char2nr("c"))] = "console.log(\r)"
vim.b[string.format("surround_%s", vim.fn.char2nr("e"))] = "${\r}"

vim.cmd("inoreabbrev <buffer><silent> clog console.log()<Left><C-R>=helpers#eatchar('\\s')<CR>")

vim.bo.path = ""

local path = table.concat({
  vim.go.path,
  "node_modules",
  "cypress/fixtures",
  table.concat(require("helpers.tsconfig").get_tsconfig_include() or {}, ","),
}, ",")

vim.opt_local.isfname:append({ "@-@" })
vim.opt_local.suffixesadd = {
  ".js",
  ".mjs",
  ".cjs",
  ".jsx",
  ".ts",
  ".tsx",
  ".d.ts",
  ".vue",
  "/package.json",
}

_G.javascript_node_find = function(target)
  if vim.fn.isdirectory(target) == 1 then
    return vim.fn.findfile("index", target)
  end

  local found = vim.fn.findfile(target, path)

  if vim.fs.basename(found) == "package.json" and vim.fs.basename(target) ~= "package.json" then
    local ok, package_json = pcall(vim.fn.readfile, found)

    if not ok then
      return found
    end

    local ok_, json = pcall(vim.fn.json_decode, table.concat(package_json, ""))

    if not ok_ then
      return found
    end

    local main = json and json["main"] or "index.js"
    return vim.fn.findfile(target .. "/" .. main, path)
  end

  return require("helpers.tsconfig").includeexpr(target)
end

vim.opt_local.includeexpr = "v:lua.javascript_node_find(v:fname)"

local javascript_autocmds = vim.api.nvim_create_augroup("JavaScriptAutocmds", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = javascript_autocmds,
  buffer = 0,
  callback = function()
    require("helpers.template_string_converter").convert()
  end,
  desc = "Automatically convert string to template string if there is an interpolation character",
})
