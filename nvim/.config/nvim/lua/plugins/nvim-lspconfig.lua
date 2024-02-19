return {
    "neovim/nvim-lspconfig",
    keys = function()
        local telescope = require("telescope.builtin")
        return {
            { "gd",         telescope.lsp_definitions,      desc = "Go to definition" },
            { "gi",         telescope.lsp_implementations,  desc = "Go to implementation" },
            { "grf",        telescope.lsp_references,       desc = "Go to references" },
            { "gt",         telescope.lsp_type_definitions, desc = "Go to type definition" },
            { "<leader>pc", telescope.diagnostics,          desc = "Go to diagnostics" },
            { "gD",         vim.lsp.buf.declaration,        desc = "Go to declaration" },
            { "gs",         vim.lsp.buf.signature_help,     desc = "Signature help" },
            { "gh",         vim.lsp.buf.hover,              desc = "Hover" },
            { "grn",        vim.lsp.buf.rename,             desc = "Rename" },
            { "<C-g><C-k>", vim.lsp.buf.signature_help,     desc = "Signature help" },
            { "<A-f>",      vim.lsp.buf.format,             desc = "Format" },
            {
                "gv",
                function()
                    local vt = vim.diagnostic.config()["virtual_text"]
                    vim.diagnostic.config({ virtual_text = not vt })
                end,
                desc = "Toggle virtual text"
            },
            {
                "[d",
                function() vim.lsp.diagnostic.goto_prev({ border = "rounded" }) end,
                desc = "Go to previous diagnostic"
            },
            {
                "gl",
                function() vim.lsp.diagnostic.open_float({ border = "rounded" }) end,
                desc = "Open diagnostic window"
            },
            {
                "]d",
                function() vim.lsp.diagnostic.goto_next({ border = "rounded" }) end,
                desc = "Go to next diagnostic"
            },
        }
    end,
    opts = {
        diagnostics = {
            virtual_text = false,
            signs = {
                active = {
                    { name = "DiagnosticSignError", text = "" },
                    { name = "DiagnosticSignWarn", text = "" },
                    { name = "DiagnosticSignHint", text = "" },
                    { name = "DiagnosticSignInfo", text = "" },
                },
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
        },
        servers = {
            "jsonls",
            "lua_ls",
            "pylsp",
            "bashls",
            "texlab",
            "ltex",
            "gopls",
            "tsserver",
        },
        on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("CursorHold", {
                pattern = "<buffer>",
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                pattern = "<buffer>",
                callback = vim.lsp.buf.clear_references,
            })
            require("lsp-inlayhints").on_attach(client, bufnr)
            require("nvim-navic").attach(client, bufnr)
        end,
        settings = {
            pylsp = {
                plugins = {
                    pycodestyle = {
                        enabled = true,
                        maxLineLength = 120,
                        ignore = {}
                    },
                    jedi_completion = {
                        eager = true,
                    },
                    rope_autoimport = {
                        enabled = true,
                        completions = {
                            enabled = false
                        }
                    },
                }
            },
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
        }
    },
    config = function(_, opts)
        vim.diagnostic.config(opts.diagnostics)
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "rounded",
        })
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = "rounded",
        })
        for _, sign in pairs(opts.diagnostics.signs.active) do
            vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
        end
        local lspconfig = require("lspconfig")
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local server_opts = {
            on_attach = opts.on_attach,
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),
            settings = opts.settings,
        }
        for _, server in pairs(opts.servers) do
            lspconfig[server].setup(server_opts)
        end
        vim.g.rustaceanvim = { server = server_opts }
    end
}
