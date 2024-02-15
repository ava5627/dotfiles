local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
    vim.notify("Cmp Not Found")
    return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
    vim.notify("LuaSnip Not Found")
    return
end

local compare_ok, compare = pcall(require, 'cmp.config.compare')
if not compare_ok then
    vim.notify("Compare Not Found")
    return
end
require("luasnip/loaders/from_vscode").lazy_load()

-- 󰃐 󰆩 󰙅 󰛡   󰅲 some other good icons
local kind_icons = {
    Text          = "󰉿 ",
    TabNine       = " ",
    Method        = "m ",
    Function      = "󰊕 ",
    Constructor   = " ",
    Field         = " ",
    Variable      = "󰆧 ",
    Class         = "󰌗 ",
    Interface     = " ",
    Module        = " ",
    Property      = " ",
    Unit          = " ",
    Value         = "󰎠 ",
    Enum          = " ",
    Keyword       = "󰌋 ",
    Snippet       = " ",
    Color         = "󰏘 ",
    File          = "󰈙 ",
    Reference     = " ",
    Folder        = "󰉋 ",
    EnumMember    = " ",
    Constant      = "󰇽 ",
    Struct        = " ",
    Event         = " ",
    Operator      = "󰆕 ",
    TypeParameter = "󰊄 ",
}

-- find more here: https://www.nerdfonts.com/cheat-sheet

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    mapping = {
        ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<A-j>"] = cmp.mapping.select_next_item({ count = 5 }),
        ["<A-k>"] = cmp.mapping.select_prev_item({ count = 5 }),
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(5), { "i", "c" }),
        ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-5), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ["<C-e>"] = cmp.mapping.abort(),
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
        ["<Tab>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                cmp_tabnine = "[TAB9]",
                nvim_lua = "[LUA]",
                luasnip = "[LSnippet]",
                buffer = "[Buffer]",
                path = "[Path]",
                spell = "[Spelling]",
            })[entry.source.name]
            return vim_item
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "cmp_tabnine" },
        { name = "luasnip" },
        { name = "nvim_lua" },
        { name = "buffer" },
        { name = "spell" },
        { name = "path" },
    },
    confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
    },
    experimental = {
        ghost_text = false,
    },
    sorting = {
        priority_weight = 2,
        comparators = {
            compare.offset,
            compare.exact,
            compare.score,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
        },
    },
})

cmp.setup.cmdline("/", {
    completion = { autocomplete = false },
    sources = {
        -- { name = 'buffer' }
        { name = "buffer", option = { keyword_pattern = [=[[^[:blank:]].*]=] } },
    },
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(":", {
    completion = { autocomplete = false },
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }),
})
