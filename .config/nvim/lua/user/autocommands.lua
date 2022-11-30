local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup


autocmd("FileType", {
    pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "lir", "fugitive", "gitcommit" },
    callback = function()
        vim.cmd [[
            nnoremap <silent> <buffer> q :close<CR>
        ]]
    end,
})


-- Yank
augroup('HighlightYank', {})
autocmd('TextYankPost', {
    group = "HighlightYank",
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

-- Remove trailing whitespace
augroup("trim_whitespace", {})
autocmd("BufWritePre",{
    group = "trim_whitespace",
    pattern = '*',
    command = "%s/\\s\\+$//e",
})


-- Fix alacritty -e bug
-- disable copilot
augroup("vim_enter", {})
autocmd("VimEnter", {
    group = "vim_enter",
    pattern = "*",
    command = "silent! exec '!kill -s SIGWINCH' getpid()",
})
autocmd("VimEnter", {
    group = "vim_enter",
    pattern = "*",
    command = "silent! Copilot disable",
})
