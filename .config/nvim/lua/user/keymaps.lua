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
kmap("n", "<a-i>", "moo<esc>`o", opts)


-- Better window navigation
kmap("n", "<leader>h", ":bnext<cr>", opts)
kmap("n", "<leader>l", ":bprevious<cr>", opts)

-- kmap("n", "<C-[", ":cprevious<cr>", opts)
-- kmap("n", "<C-]", ":cnext<cr>", opts)

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

-- kmap("i", ":w", "<ESC>:w<cr>", opts)

kmap("i", "<A-d>", "<DELETE>", opts)
kmap("i", "<C-d>", "<C-o>dw", opts)

kmap("i", "<C-p>", "<left><C-o>p", opts)

kmap("i", "jj", "<ESC>", opts)

-- Indent Jump
kmap("", "[q", "<Plug>(IndentWisePreviousLesserIndent)", {silent=true})
kmap("", "[w", "<Plug>(IndentWisePreviousEqualIndent)", {silent=true})
kmap("", "[e", "<Plug>(IndentWisePreviousGreaterIndent)", {silent=true})

kmap("", "]q", "<Plug>(IndentWiseNextLesserIndent)", {silent=true})
kmap("", "]w", "<Plug>(IndentWiseNextEqualIndent)", {silent=true})
kmap("", "]e", "<Plug>(IndentWiseNextGreaterIndent)", {silent=true})

kmap("", "[_", "<Plug>(IndentWisePreviousAbsoluteIndent)", {silent=true})
kmap("", "]_", "<Plug>(IndentWiseNextAbsoluteIndent)", {silent=true})

kmap("", "[%", "<Plug>(IndentWiseBlockScopeBoundaryBegin)", {silent=true})
kmap("", "]%", "<Plug>(IndentWiseBlockScopeBoundaryEnd)", {silent=true})

-- Visual
kmap("v", "<", "<gv", opts)
kmap("v", ">", ">gv", opts)

kmap("v", "<S-j>", ":m '>+1<CR>gv=gv", opts)
kmap("v", "<S-k>", ":m '<-2<CR>gv=gv", opts)
kmap("v", "p", '"_dP', opts)

-- Telescope
kmap("n", "<leader>pp", "<cmd>Telescope find_files<cr>", opts)
kmap("n", "<leader>ph", "<cmd>Telescope find_files<cr>", opts)
kmap("n", "<leader>pg", "<cmd>Telescope live_grep<cr>", opts)
kmap("n", "<leader>pw", "<cmd>lua require('telescope.builtin').grep_string { search = vim.fn.expand(\"<cword>\") }<cr>", opts)
kmap("n", "<leader>pb", "<cmd>Telescope buffers<cr>", opts)
kmap("n", "<leader>po", "<cmd>Telescope project project<cr>", opts)

-- LSP
kmap("n", "<leader>m", ":Format<cr>", opts)

-- Git
kmap("n", "<leader>gs", ":G<cr>", opts)
kmap("n", "<leader>gf", ":diffget //2<cr>", opts)
kmap("n", "<leader>gj", ":diffget //3<cr>", opts)

-- Undo tree
kmap("n", "<leader>u", ":UndotreeShow<cr>", opts)

-- Toggle Term
kmap("n", "<C-t>p", "<cmd>lua _PYTHON_TOGGLE()<cr>", opts)
kmap("t", "<C-t>p", "<cmd>lua _PYTHON_TOGGLE()<cr>", opts)

kmap("n", "<C-t>g", "<cmd>lua _LAZYGIT_TOGGLE()<cr>", opts)
kmap("t", "<C-t>g", "<cmd>lua _LAZYGIT_TOGGLE()<cr>", opts)

-- Copilot
kmap("i", "<C-a>", "copilot#Accept(\"\\<CR>\")", {noremap=false, silent=true, script=true, expr=true})
kmap("i", "<C-q><C-q>", "<C-o>:Copilot disable<cr>", opts)
kmap("i", "<C-q><C-e>", "<C-o>:Copilot enable<cr>", opts)
vim.g.copilot_no_tab_map = true

-- Dial
kmap("n", "<C-a>", require("dial.map").inc_normal(), {noremap = true})
kmap("n", "<C-x>", require("dial.map").dec_normal(), {noremap = true})
kmap("v", "<C-a>", require("dial.map").inc_visual(), {noremap = true})
kmap("v", "<C-x>", require("dial.map").dec_visual(), {noremap = true})
kmap("v", "g<C-a>", require("dial.map").inc_gvisual(), {noremap = true})
kmap("v", "g<C-x>", require("dial.map").dec_gvisual(), {noremap = true})

-- Debugging
vim.g.vimspector_enable_mappings = 'HUMAN'
kmap("n", "<F3>", ":VimspectorReset<cr>", opts)

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Yank
local yank_group = augroup('HighlightYank', {})
autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

-- Remove trailing whitespace
local trim_whitespace = augroup("trim_whitespace", {})
autocmd("BufWritePre",{
    group = trim_whitespace,
    pattern = '*',
    command = "%s/\\s+$//e",
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

function _G.ReloadConfig()
    for name,_ in pairs(package.loaded) do
        if name:match('^user') then
            package.loaded[name] = nil
        end
    end
    dofile(vim.env.MYVIMRC)
    vim.notify("Reloaded Config")
end

vim.cmd("command! ReloadConfig lua ReloadConfig()")
kmap("n", "<leader><cr>", "<Cmd>lua ReloadConfig()<CR>", opts)

