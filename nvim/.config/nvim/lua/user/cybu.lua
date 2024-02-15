require("cybu").setup({
    position = {
        anchor = "topright",         -- topleft, topcenter, topright,
        vertical_offset = 5,         -- vertical offset from anchor in lines
        horizontal_offset = 5,        -- vertical offset from anchor in columns
    },
    style = {
        path = "relative",            -- absolute, relative, tail (filename only)
        path_abbreviation = "none",   -- none, shortened
    },
    display_time = 1000,             -- time the cybu window is displayed
    exclude = {                     -- filetypes, cybu will not be active
        "fugitive",
        "qf",
        "NvimTree",
    },
})
