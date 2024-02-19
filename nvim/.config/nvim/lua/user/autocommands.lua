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

-- autocmd("TermOpen", {
--     pattern = "term://*",
--     callback = function()
--         local opts = { silent = true, noremap = true, buffer = true }
--         kmap("t", "<esc>", [[<C-\><C-n>]], opts)
--         kmap("t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
--         kmap("t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
--         kmap("t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
--         kmap("t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
--         kmap("n", "<C-c>", "a<C-c>", opts)
--     end,
-- })
