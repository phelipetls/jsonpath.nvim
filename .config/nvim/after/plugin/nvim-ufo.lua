require("ufo").setup({
  provider_selector = function(_, filetype)
    if filetype == "gitcommit" then
      return ""
    end
  end,
})

vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
