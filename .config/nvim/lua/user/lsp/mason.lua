local status_ok, mason = pcall(require, "mason")
if not status_ok then
    return
end

local status_ok_1, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok_1 then
    return
end

local servers = {
    "jsonls",
    "sumneko_lua",
    "pylsp",
    "yamlls",
    "bashls",
    "clangd",
    "texlab",
    "ltex",
    "jdtls",
    "gopls",
}


local settings = {
    ui = {
        border = "rounded",
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        },
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
}

mason.setup(settings)
mason_lspconfig.setup {
    ensure_installed = servers,
    automatic_installation = true,
}

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
    return
end

local opts = {}
for _, server in pairs(servers) do
    opts = {
        on_attach = require("user.lsp.handlers").on_attach,
        capabilities = require("user.lsp.handlers").capabilities,
    }

    server = vim.split(server, "@")[1]

    if server == "jsonls" then
        local jsonls_opts = require "user.lsp.settings.jsonls"
        opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
    end

    if server == "sumneko_lua" then
        local nd_status_ok, neodev = pcall(require, "neodev")
        if not nd_status_ok then
            vim.notify("neodev not found", vim.log.levels.ERROR)
            goto continue
        end
        -- local sumneko_opts = require "user.lsp.settings.sumneko_lua"
        -- opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
        -- opts = vim.tbl_deep_extend("force", require("lua-dev").setup(), opts)
        neodev.setup {
            -- add any options here, or leave empty to use the default settings
        }
        lspconfig.sumneko_lua.setup({
            on_attach = opts.on_attach,
            capabilities = opts.capabilities,
        })
        goto continue
    end

    if server == "pylsp" then
        local pylsp_opts = require "user.lsp.settings.pylsp"
        opts = vim.tbl_deep_extend("force", pylsp_opts, opts)
    end

    if server == "jdtls" then
        goto continue
    end

    lspconfig[server].setup(opts)
    ::continue::
end
