local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("FileType", {
	pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "lir", "fugitive", "gitcommit", "git" },
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "q", ":close<CR>", { silent = true, noremap = true })
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

-- disable copilot
augroup("vim_enter", {})
autocmd("VimEnter", {
	group = "vim_enter",
	pattern = "*",
	command = "silent! Copilot disable",
})

-- local function open_nvim_tree(data)
--     local ok, nvt_api = pcall(require, "nvim-tree.api")
--     if not ok then
--         vim.notify("Nvim Tree not found")
--         return
--     end
--
-- 	local is_dir = vim.fn.isdirectory(data.file) == 1
--     print(is_dir, data.file)
-- 	if is_dir then
-- 		vim.cmd.cd(data.file)
--         nvt_api.tree.open()
--     else
--         local parent_dir = vim.fn.fnamemodify(data.file, ":h")
--         vim.cmd.cd(parent_dir)
--         -- nvt_api.tree.toggle({ focus = false })
--     end
-- end

-- autocmd("VimEnter", {
-- 	group = "vim_enter",
-- 	pattern = "*",
-- 	callback = open_nvim_tree,
-- })
