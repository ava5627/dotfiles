local dap_ok, dap = pcall(require, "dap")
if not dap_ok then
    vim.notify("DAP not found", vim.log.levels.ERROR)
    return
end

local function rust_debug()
    if dap.status() == "" then
        vim.cmd([[RustLsp debuggables]])
    else
        dap.continue()
    end
end

vim.g.rustaceanvim = {
    server = {
        on_attach = require("user.lsp.handlers").on_attach,
        capabilities = require("user.lsp.handlers").capabilities,

        settings = {
            ["rust-analyzer"] = {
                lens = {
                    enable = true,
                },
                hover = {
                    links = {
                        enable = false,
                    }
                }
            },
        },

    }
}

local buffnr = vim.api.nvim_get_current_buf()
vim.keymap.set("n", "<F5>", rust_debug, { noremap = true, silent = true })
vim.keymap.set("n", "J", "<cmd>RustLsp joinLines<CR>", { noremap = true, silent = true, buffer = buffnr })
