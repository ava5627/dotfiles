-- vim.wo["spell"] = true
local kmap = vim.api.nvim_set_keymap

kmap("i", "<c-f>", "<Esc>[dga`]i", {noremap = false, silent = true})

vim.api.nvim_create_augroup("vimtex", {})
vim.api.nvim_create_autocmd( {"User"}, {
    pattern = "VimtexEventQuit",
    group = "vimtex",
    command = "VimtexClean"
})
