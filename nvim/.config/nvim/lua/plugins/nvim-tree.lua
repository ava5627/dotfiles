local home = vim.fn.expand("~")
local function on_attach(bufnr)
    local nt_api = require("nvim-tree.api")
    local function opts(desc)
        return { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    nt_api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set("n", "l", nt_api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "v", nt_api.node.open.vertical, opts("Open Vertical Split"))
    vim.keymap.set("n", "s", nt_api.node.open.horizontal, opts("Open Horizontal Split"))
    vim.keymap.set("n", "h", nt_api.node.navigate.parent_close, opts("Close"))
    vim.keymap.set("n", "<BS>", "<leader>",
        { desc = "Backspace leader", buffer = bufnr, remap = true, silent = true, nowait = true })
    vim.keymap.set("n", "]d", nt_api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
    vim.keymap.set("n", "[d", nt_api.node.navigate.diagnostics.prev, opts("Previous Diagnostic"))
end

return {
    "kyazdani42/nvim-tree.lua",
    dev = vim.loop.fs_stat(home .. "/repos/nvim-tree.lua") ~= nil,
    opts = {
        hijack_cursor = true,
        sync_root_with_cwd = true,
        on_attach = on_attach,
        renderer = {
            indent_markers = {
                enable = true,
                inline_arrows = true,
            },
            icons = {
                git_placement = "after",
                glyphs = {
                    default = "󰈔",
                    symlink = "",
                    git = {
                        unstaged = "●",
                        ignored = "●",
                    },
                },
            },
        },
        update_focused_file = {
            enable = true,
            exclude = { "gitcommit", "COMMIT_EDITMSG" },
        },
        diagnostics = {
            enable = true,
            show_on_dirs = true,
        },
    },
    config = function(_, opts)
        vim.cmd [[hi link NvimTreeExecFile Normal]]
        require("nvim-tree").setup(opts)
    end,
    keys = {
        { "<leader>e", function() require("nvim-tree.api").tree.toggle({ focus = false }) end, desc = "Toggle file explorer" }
    }
}
