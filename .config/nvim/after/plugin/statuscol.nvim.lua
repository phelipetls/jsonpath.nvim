require("statuscol").setup({
  segments = {
    { text = { require("statuscol.builtin").lnumfunc }, click = "v:lua.ScLa" },
    { text = { require("statuscol.builtin").foldfunc }, click = "v:lua.ScFa" },
    { text = { " " } },
  },
})
