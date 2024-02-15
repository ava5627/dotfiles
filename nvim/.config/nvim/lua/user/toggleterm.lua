local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	vim.notify("Toggleterm Not Found")
	return
end
toggleterm.setup({
	size = 20,
	open_mapping = [[<c-esc>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "term://*",
    callback = function()
        local opts = { silent = true, noremap = true }
        vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
        vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
        vim.api.nvim_buf_set_keymap(0, "n", "<C-c>", "a<C-c>", opts)
    end,
})

local Terminal = require("toggleterm.terminal").Terminal

local python = Terminal:new({ cmd = "ipython3", hidden = true })
function _PYTHON_TOGGLE()
	python:toggle()
end
