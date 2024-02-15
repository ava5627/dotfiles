require("tokyonight").setup({
    -- use the night style
    style = "night",
    sidebars = { "qf", "vista_kind", "terminal", "packer", "NvimTree" },
    -- Change the "hint" color to the "orange" color, and make the "error" color bright red
    on_colors = function(colors)
        colors.git.add = colors.hint
        colors.gitSigns.add = colors.hint
    end,
    on_highlights = function (highlights, colors)
        highlights.NvimTreeGitDirty = {
            fg = colors.blue,
            bg = highlights.NvimTreeGitDirty.bg
        }
        highlights.Operator = { fg = colors.red }
        highlights.TSOperator = { fg = colors.red }
        highlights.DiagnosticUnnecessary = { fg = colors.fg_dark, undercurl=true, sp=colors.warning }
        highlights.CybuFocus = { bg = highlights.Visual.bg }
    end

})
