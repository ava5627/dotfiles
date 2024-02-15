-- vim.wo["spell"] = true
vim.api.nvim_create_augroup("vimtex", {})
vim.api.nvim_create_autocmd( {"User"}, {
    pattern = "VimtexEventQuit",
    group = "vimtex",
    command = "VimtexClean"
})
