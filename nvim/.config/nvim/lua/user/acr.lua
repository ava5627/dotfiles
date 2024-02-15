local status_ok, acr = pcall(require, "acr")
if not status_ok then
    vim.notify("acr.nvim not found", vim.log.levels.ERROR)
    return
end

acr.setup({
    cmds = {
        python = "python %",
        rust = "cargo run",
        java = "java %",
    },
    term_opts = {
        direction = "horizontal",
        on_open = function()
            vim.cmd(":NvimTreeToggle")
            vim.cmd(":NvimTreeToggle")
            vim.cmd("wincmd p")
        end,
    }
})
