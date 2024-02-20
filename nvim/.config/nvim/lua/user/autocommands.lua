local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local kmap = vim.keymap.set

augroup("Filetype", {})
autocmd("FileType", {
    group = "Filetype",
    pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "lir", "fugitive", "gitcommit", "git", "toggleterm" },
    callback = function()
        kmap("n", "q", ":close<CR>", { silent = true, noremap = true, buffer = true })
    end,
})

-- Yank
augroup("HighlightYank", {})
autocmd("TextYankPost", {
    group = "HighlightYank",
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 40,
        })
    end,
})

-- Remove trailing whitespace
augroup("trim_whitespace", {})
autocmd("BufWritePre", {
    group = "trim_whitespace",
    pattern = "*",
    command = "%s/\\s\\+$//e",
})
