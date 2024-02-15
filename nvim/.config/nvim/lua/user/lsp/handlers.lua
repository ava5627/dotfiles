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
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup("lsp_document_highlight", {})
        vim.api.nvim_create_autocmd("CursorHold", {
            pattern = "<buffer>",
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            pattern = "<buffer>",
            callback = vim.lsp.buf.clear_references,
        })
    end
end

local function lsp_keymaps(bufnr)
    local function opts(desc)
        return { desc = desc, buffer = bufnr, noremap = true, silent = true }
    end
    local function kmap(mode, keys, action, options)
        vim.keymap.set(mode, keys, action, options)
        local ok, which_key = pcall(require, "which-key")
        if ok then
            which_key.register({
                [keys] = { name = options["desc"] }
            })
        end
    end
    local ts_status, telescope = pcall(require, "telescope.builtin")
    if ts_status then
        kmap("n", "gd", telescope.lsp_definitions, opts("Go to definition"))
        kmap("n", "gi", telescope.lsp_implementations, opts("Go to implementation"))
        kmap("n", "grf", telescope.lsp_references, opts("Go to references"))
        kmap("n", "gt", telescope.lsp_type_definitions, opts("Go to type definition"))
        kmap("n", "<leader>pc", telescope.diagnostics, opts("Go to diagnostics"))
    else
        kmap("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
        kmap("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
        kmap("n", "grf", vim.lsp.buf.references, opts("Go to references"))
        kmap("n", "gt", vim.lsp.buf.type_definition, opts("Go to type definition"))
        kmap("n", "<leader>pc", vim.diagnostic.setqflist, opts("Go to diagnostics"))
    end
    kmap("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
    kmap("n", "gh", vim.lsp.buf.hover, opts("Hover"))
    if vim.bo.filetype == "rust" then
        kmap("n", "gh", "<cmd>RustLsp hover actions<CR>", opts("Hover"))
        kmap("v", "gh", "<cmd>RustLsp hover range<CR>", opts("Hover"))
    end
    kmap("n", "gs", vim.lsp.buf.signature_help, opts("Signature help"))
    kmap("i", "<C-g><C-k>", vim.lsp.buf.signature_help, opts("Signature help"))
    kmap("n", "grn", vim.lsp.buf.rename, opts("Rename"))
    kmap({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts("Code actions"))
    kmap({ "i", "n", "v" }, "<A-return>", vim.lsp.buf.code_action, opts("Code actions"))
    -- kmap("n", "<leader>f", vim.diagnostic.open_float, opts)
    kmap("n", "[d", function()
        vim.diagnostic.goto_prev({ border = "rounded" })
    end, opts("Go to previous diagnostic"))
    kmap("n", "gl", function()
        vim.diagnostic.open_float({ border = "rounded" })
    end, opts("Open diagnostic window"))
    -- kmap("n", "gs", vim.diagnostic.show, opts)
    -- kmap("n", "gh", vim.diagnostic.hide, opts)
    kmap("n", "]d", function()
        vim.diagnostic.goto_next({ border = "rounded" })
    end, opts("Go to next diagnostic"))
    kmap("n", "<A-f>", vim.lsp.buf.format, opts("Format"))
    kmap("n", "gv", function()
        local vt = vim.diagnostic.config()["virtual_text"]
        vim.diagnostic.config({ virtual_text = not vt })
    end, opts("Toggle virtual text"))
end

M.on_attach = function(client, bufnr)
    lsp_keymaps(bufnr)
    lsp_highlight_document(client)

    local inlay_ok, inlay = pcall(require, "lsp-inlayhints")
    if inlay_ok then
        inlay.on_attach(client, bufnr)
    end

    if client.server_capabilities.documentSymbolProvider then
        local _, navic = pcall(require, "nvim-navic")
        navic.attach(client, bufnr)
    end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
    return
end

M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

return M
