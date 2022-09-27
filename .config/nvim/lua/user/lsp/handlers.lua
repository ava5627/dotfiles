local M = {}

M.setup = function()
    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local config = {
        virtual_text = false,
        signs = {
            active = signs,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })
end

local function lsp_highlight_document(client)
    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_create_augroup("lsp_document_highlight", {})
        vim.api.nvim_create_autocmd("CursorHold", {
            pattern = "<buffer>",
            callback = vim.lsp.buf.document_highlight
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            pattern = "<buffer>",
            callback = vim.lsp.buf.clear_references
        })
    end
end

local function lsp_keymaps(bufnr)
    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("i", "<C-g><C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "grf", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
    vim.keymap.set("v", "ga", vim.lsp.buf.range_code_action, opts)
    -- vim.keymap.set("n", "<leader>f", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev({ border = "rounded" }) end, opts)
    vim.keymap.set("n", "gl", function() vim.diagnostic.open_float({ border = "rounded" }) end, opts)
    -- vim.keymap.set("n", "gs", vim.diagnostic.show, opts)
    -- vim.keymap.set("n", "gh", vim.diagnostic.hide, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next({ border = "rounded" }) end, opts)
    vim.keymap.set("n", "<leader>c", vim.diagnostic.setqflist, opts)
    vim.keymap.set("n", "<leader>m", vim.lsp.buf.formatting, opts)
end

M.on_attach = function(client, bufnr)
    if client.name == "tsserver" then
        client.resolved_capabilities.document_formatting = false
    elseif client.name == "jdtls" then
        if JAVA_DAP_ACTIVE then
            require("jdtls").setup_dap { hotcodereplace = "auto" }
            require("jdtls.dap").setup_dap_main_class_configs()
        end
    end

    lsp_keymaps(bufnr)
    lsp_highlight_document(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
    return
end

M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

return M
