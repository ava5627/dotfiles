local dap_ok, dap = pcall(require, "dap")
if not dap_ok then
    vim.notify("DAP not found", vim.log.levels.ERROR)
    return
else
    local function rust_debug()
        if dap.status() == "" then
            vim.cmd([[RustLsp debuggables]])
        else
            dap.continue()
        end
    end
    vim.keymap.set("n", "<F5>", rust_debug, { noremap = true, silent = true })
end

vim.keymap.set("n", "J", "<cmd>RustLsp joinLines<CR>", { noremap = true, silent = true, buffer = 0 })
