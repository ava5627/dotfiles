local status_ok, acr = pcall(require, "acr")
if not status_ok then
    vim.notify("acr.nvim not found", vim.log.levels.ERROR)
    return
end
local nvim_tree_ok, nvim_tree = pcall(require, "nvim-tree.api")
local on_open = nil
if nvim_tree_ok then
    on_open = function()
        nvim_tree.tree.toggle({ focus = false })
        nvim_tree.tree.toggle({ focus = false })
    end
end


acr.setup({
    cmds = {
        python = "python %",
        rust = "cargo run",
        java = "java %",
    },
    term_opts = {
        direction = "horizontal",
        on_open = on_open,
    }
})
