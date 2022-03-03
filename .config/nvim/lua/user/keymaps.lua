local opts = {noremap = true, silent = true}

local kmap = vim.api.nvim_set_keymap

kmap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Misc
kmap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)
kmap("n", "<leader>ww", ":w<cr>", opts)
kmap("n", "<leader>wq", ":wq<cr>", opts)
kmap("n", "<leader>q", ":q<cr>", opts)

kmap("n", "<A-a>", ":nohl<cr>", opts)
kmap("n", "<a-o>", "moO<esc>`o", opts)

-- Better window navigation
kmap("n", "<leader>l", ":bnext<cr>", opts)
kmap("n", "<leader>h", ":bprevious<cr>", opts)

kmap("n", "<C-h>", "<C-w>h", opts)
kmap("n", "<C-j>", "<C-w>j", opts)
kmap("n", "<C-k>", "<C-w>k", opts)
kmap("n", "<C-l>", "<C-w>l", opts)

kmap("n", "<A-k>", ":resize +5<cr>", opts)
kmap("n", "<A-j>", ":resize -5<cr>", opts)
kmap("n", "<A-h>", ":vertical resize +5<cr>", opts)
kmap("n", "<A-l>", ":vertical resize -5<cr>", opts)

kmap("n", "<leader>v", "<C-w>v", opts)
kmap("n", "<leader>o", "<C-w>o", opts)
kmap("n", "<leader>s", "<C-w>s", opts)

-- Insert Mode
kmap("i", "<A-h>", "<left>", opts)
kmap("i", "<A-j>", "<down>", opts)
kmap("i", "<A-k>", "<up>", opts)
kmap("i", "<A-l>", "<right>", opts)

kmap("i", ":w", "<ESC>:w<cr>", opts)

kmap("i", "<A-d>", "<DELETE>", opts)
kmap("i", "<C-d>", "<C-o>dw", opts)

kmap("i", "<C-p>", "<left><C-o>p", opts)

kmap("i", "jj", "<ESC>", opts)

-- Indent Jump
kmap("n", "[q", "<Plug>(IndentWisePreviousLesserIndent)", {silent=true})
kmap("n", "[w", "<Plug>(IndentWisePreviousEqualIndent)", {silent=true})
kmap("n", "[e", "<Plug>(IndentWisePreviousGreaterIndent)", {silent=true})

kmap("n", "]q", "<Plug>(IndentWiseNextLesserIndent)", {silent=true})
kmap("n", "]w", "<Plug>(IndentWiseNextEqualIndent)", {silent=true})
kmap("n", "]e", "<Plug>(IndentWiseNextGreaterIndent)", {silent=true})

kmap("n", "[_", "<Plug>(IndentWisePreviousAbsoluteIndent)", {silent=true})
kmap("n", "]_", "<Plug>(IndentWiseNextAbsoluteIndent)", {silent=true})

kmap("n", "[%", "<Plug>(IndentWiseBlockScopeBoundaryBegin)", {silent=true})
kmap("n", "]%", "<Plug>(IndentWiseBlockScopeBoundaryEnd)", {silent=true})

-- Visual
kmap("v", "<", "<gv", opts)
kmap("v", ">", ">gv", opts)

kmap("v", "<S-j>", ":m '>+1<CR>gv=gv", opts)
kmap("v", "<S-k>", ":m '<-2<CR>gv=gv", opts)
kmap("v", "p", '"_dP', opts)

-- Telescope
kmap("n", "<leader>pp", "<cmd>Telescope find_files<cr>", opts)
kmap("n", "<leader>pg", "<cmd>Telescope live_grep<cr>", opts)
kmap("n", "<leader>pw", "<cmd>lua require('telescope.builtin').grep_string { search = vim.fn.expand(\"<cword>\") }<cr>", opts)
kmap("n", "<leader>pb", "<cmd>Telescope buffers<cr>", opts)

-- LSP
kmap("n", "<leader>m", ":Format<cr>", opts)

-- Git
kmap("n", "<leader>gs", ":G<cr>", opts)
kmap("n", "<leader>gf", ":diffget //2<cr>", opts)
kmap("n", "<leader>gj", ":diffget //3<cr>", opts)

-- Debuger
vim.g.vimspector_enable_mappings = 'HUMAN'
kmap("n", "<leader>d", ":VimspectorReset<cr>", opts)

-- Toggle Term
kmap("n", "<C-t>p", "<cmd>lua _PYTHON_TOGGLE()<cr>", opts)
kmap("t", "<C-t>p", "<cmd>lua _PYTHON_TOGGLE()<cr>", opts)

kmap("n", "<C-t>g", "<cmd>lua _LAZYGIT_TOGGLE()<cr>", opts)
kmap("t", "<C-t>g", "<cmd>lua _LAZYGIT_TOGGLE()<cr>", opts)

-- Yank
vim.cmd [[ 
    augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
    augroup END
]]

-- Fix alacritty -e bug
vim.cmd [[
    autocmd VimEnter * :silent exec "!kill -s SIGWINCH" getpid()
]]

function _G.ReloadConfig()
    for name,_ in pairs(package.loaded) do
        if name:match('^user') then
            package.loaded[name] = nil
        end
    end
    dofile(vim.env.MYVIMRC)
    vim.notify("Reloaded Config")
end

vim.api.nvim_set_keymap('n', '<Leader><cr>', '<Cmd>lua ReloadConfig()<CR>', { silent = true, noremap = true })
vim.cmd('command! ReloadConfig lua ReloadConfig()')
