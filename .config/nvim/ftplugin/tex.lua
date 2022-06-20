-- vim.wo["spell"] = true

if vim.g.vim_window_id == nil then
    local openPop = assert(io.popen('xdotool getactivewindow', 'r'))
    local output = openPop:read('*all')
    openPop:close()
    vim.g.vim_window_id = output
end

function TexFocusVim()
    os.execute("sleep .05 && xdotool windowactivate " .. vim.g.vim_window_id)
end

vim.api.nvim_create_augroup("vimtex_event_focus", {})
vim.api.nvim_create_autocmd( {"User"}, {
    pattern = "VimtexEventView",
    group = "vimtex_event_focus",
    command = "lua TexFocusVim()"
})
