M = {}

vim.api.nvim_create_user_command(
    "JsonPathCopy",
    function()
        local show_on_winbar = require("jsonpath").opts.show_on_winbar
        if show_on_winbar and vim.fn.exists("+winbar") == 1 then
            vim.opt_local.winbar = "%{%v:lua.require'jsonpath'.get()%}"
        end

        local reg = require("jsonpath").opts.reg
        vim.fn.setreg(reg, require("jsonpath").get())
    end,
    {}
)

return M
