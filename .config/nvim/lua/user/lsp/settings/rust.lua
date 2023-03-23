return {
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
