local opts = {
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
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
