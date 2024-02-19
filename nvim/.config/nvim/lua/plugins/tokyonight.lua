return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        style = "night",
        on_colors = function(colors)
            colors.git.add = colors.hint
            colors.gitSigns.add = colors.hint
        end,
        on_highlights = function(highlights, colors)
            highlights.NvimTreeGitDirty = {
                fg = colors.blue,
                bg = highlights.NvimTreeGitDirty.bg
            }
            highlights.Operator = { fg = colors.red }
            highlights.TSOperator = { fg = colors.red }
            highlights.DiagnosticUnnecessary = { fg = colors.fg_dark, undercurl = true, sp = colors.warning }
            highlights.CybuFocus = { bg = highlights.Visual.bg }
        end
    },
    config = function(_, opts)
        require("tokyonight").setup(opts)
        vim.cmd("colorscheme tokyonight")
    end,
}
