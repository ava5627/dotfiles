-- each of these are documented in `:help nvim-tree.OPTION_NAME`

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    vim.notify("Nvim Tree Not Found")
    return
end

local function on_attach(bufnr)
    local nt_api_ok, nt_api = pcall(require, "nvim-tree.api")
    if not nt_api_ok then
        vim.notify("Nvim Tree API Not Found")
        return
    end
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

nvim_tree.setup({
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
})

vim.cmd [[hi link NvimTreeExecFile Normal]]
