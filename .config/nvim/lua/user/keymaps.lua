local opts = {noremap = true, silent = true}

local kmap = vim.api.nvim_set_keymap

kmap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

kmap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)
kmap("n", "<leader>l", ":bnext<cr>", opts)
kmap("n", "<leader>h", ":bprevious<cr>", opts)

-- Better window navigation
kmap("n", "<C-h>", "<C-w>h", opts)
kmap("n", "<C-j>", "<C-w>j", opts)
kmap("n", "<C-k>", "<C-w>k", opts)
kmap("n", "<C-l>", "<C-w>l", opts)

kmap("n", "<a-l>", ":nohl<cr>", opts)

kmap("i", "<A-h>", "<left>", opts)
kmap("i", "<A-j>", "<down>", opts)
kmap("i", "<A-k>", "<up>", opts)
kmap("i", "<A-l>", "<right>", opts)

kmap("i", "<A-d>", "<DELETE>", opts)
kmap("i", "<C-d>", "<C-o>dw", opts)

kmap("i", "<C-p>", "<C-o>p", opts)

kmap("i", "jj", "<ESC>", opts)


kmap("v", "<", "<gv", opts)
kmap("v", ">", ">gv", opts)

kmap("v", "<S-j>", ":m '>+1<CR>gv=gv", opts)
kmap("v", "<S-k>", ":m '<-2<CR>gv=gv", opts)
kmap("v", "p", '"_dP', opts)

kmap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
kmap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
kmap("n", "<leader>fw", "<cmd>lua require('telescope.builtin').grep_string { search = vim.fn.expand(\"<cword>\") }<cr>", opts)
kmap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)

kmap("n", "<leader>m", ":Format<cr>", opts)
kmap("n", "<Leader><CR>", ":so ~/.config/nvim/init.vim<CR>", opts)

vim.cmd [[ 
    augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
    augroup END
]]
