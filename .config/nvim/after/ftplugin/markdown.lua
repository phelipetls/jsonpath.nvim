vim.wo.spell = true
vim.bo.spelllang = "pt,en_us"
vim.wo.conceallevel = 0

vim.opt_local.iskeyword:append({ "'" })

-- allow syntax highlight inside code blocks for these languages
vim.g.markdown_fenced_languages = {
  'vim',
  'python',
  'javascript',
  'js=javascript',
  'jsx=javascriptreact',
  'typescript',
  'ts=typescript',
  'tsx=typescriptreact',
}

vim.b[string.format("surround_%s", vim.fn.char2nr("c"))] = "```\r\n```"
vim.b[string.format("surround_%s", vim.fn.char2nr("l"))] = "[\r](\1link: \1)"
vim.b[string.format("surround_%s", vim.fn.char2nr("*"))] = "*\r*"

vim.b.match_words = table.concat({ vim.b.match_words or "", [[^```.\+$:^```$]] }, ",")
