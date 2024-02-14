local status_ok, lsp_signature = pcall(require, "lsp_signature")
if not status_ok then
    vim.api.nvim_err_writeln("Failed to load lsp_signature")
    return
end

lsp_signature.setup {
    floating_window = false,
    hint_enable = true, -- virtual hint enable
    hint_prefix = "󰏫 ",  -- Pencil for parameter
    hint_scheme = "String",
    hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
}
