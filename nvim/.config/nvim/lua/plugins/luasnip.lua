return {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    lazy = false,
    keys = function()
        local lua_snip = require("luasnip")
        return {
            { "<C-i>", lua_snip.expand, desc = "Expand snippet", mode = { "i", "s" } },
            {
                "<C-l>",
                function()
                    if lua_snip.locally_jumpable(1) then
                        lua_snip.jump(1)
                    end
                end,
                desc = "Next snippet",
                mode = { "i", "s" }
            },
            {
                "<C-k>",
                function()
                    if lua_snip.locally_jumpable(-1) then
                        lua_snip.jump(-1)
                    end
                end,
                desc = "Previous snippet",
                mode = { "i", "s" }
            }
        }
    end
}
