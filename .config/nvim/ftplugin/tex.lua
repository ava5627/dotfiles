-- vim.wo["spell"] = true
local kmap = vim.api.nvim_set_keymap

kmap("i", "<c-f>", "<Esc>[dga`]a", {noremap = false, silent = true})


if vim.g.vim_window_id == nil then
    local openPop = assert(io.popen('xdotool getactivewindow', 'r'))
    local output = openPop:read('*all')
    openPop:close()
    vim.g.vim_window_id = output
end

function TexFocusVim()
    os.execute("sleep .05 && xdotool windowactivate " .. vim.g.vim_window_id)
end

vim.api.nvim_create_augroup("vimtex", {})
vim.api.nvim_create_autocmd( {"User"}, {
    pattern = "VimtexEventView",
    group = "vimtex",
    callback = TexFocusVim,
})
vim.api.nvim_create_autocmd( {"User"}, {
    pattern = "VimtexEventQuit",
    group = "vimtex",
    command = "VimtexClean"
})
