local opts = {
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
                }
            }
        }
    }
}

return opts
