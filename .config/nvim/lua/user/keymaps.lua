local opts = { noremap = true, silent = true }

local kmap = vim.keymap.set

kmap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Misc
kmap("n", "<leader>ww", ":w<cr>", opts)
kmap("n", "<leader>wq", ":bdelete<cr>", opts)
kmap("n", "<leader>q", ":Bdelete<cr>", opts)
kmap("n", "<leader>fq", ":Bdelete!<cr>", opts)

-- Clear search highlights
kmap("n", "<A-a>", ":nohl<cr>", opts)

-- Insert line above/below without leaving normal mode
kmap("n", "<a-o>", "moO<esc>`o", opts)
kmap("n", "<a-i>", "moo<esc>`o", opts)

-- Better window navigation
kmap("n", "<C-h>", "<C-w>h", opts)
kmap("n", "<C-j>", "<C-w>j", opts)
kmap("n", "<C-k>", "<C-w>k", opts)
kmap("n", "<C-l>", "<C-w>l", opts)
kmap("n", "<C-q>", "<C-w>q", opts)

-- Switch Buffers
kmap("n", "<A-l>", ":BufferLineCycleNext<CR>", opts)
kmap("n", "<A-h>", ":BufferLineCyclePrev<CR>", opts)


-- Quick fix list
kmap("n", "<leader>co", ":copen<cr><C-w>p", opts)
kmap("n", "<leader>cc", ":cclose<cr>", opts)
kmap("n", "<leader>cn", ":cnext<cr>", opts)
kmap("n", "<leader>cp", ":cprev<cr>", opts)

-- Resize windows with arrow keys
kmap("n", "<A-Up>", ":resize +5<cr>", opts)
kmap("n", "<A-Down>", ":resize -5<cr>", opts)
kmap("n", "<A-Left>", ":vertical resize +5<cr>", opts)
kmap("n", "<A-Right>", ":vertical resize -5<cr>", opts)

-- Open/Close windows
kmap("n", "<leader>v", "<C-w>v", opts)
kmap("n", "<leader>s", "<C-w>s", opts)

-- Insert Mode
kmap("i", "<A-h>", "<left>", opts)
kmap("i", "<A-j>", "<down>", opts)
kmap("i", "<A-k>", "<up>", opts)
kmap("i", "<A-l>", "<right>", opts)

-- kmap("i", ":w", "<ESC>:w<cr>", opts)

-- Delete backwards
kmap("i", "<A-d>", "<C-o>dw", opts)
kmap("i", "<A-w>", "<BACKSPACE>", opts)

-- Paste in insert mode
kmap("i", "<C-p>", "<left><C-o>p", opts)

-- Indent Jump
kmap("", "[q", "<Plug>(IndentWisePreviousLesserIndent)", { silent = true })
kmap("", "[w", "<Plug>(IndentWisePreviousEqualIndent)", { silent = true })
kmap("", "[e", "<Plug>(IndentWisePreviousGreaterIndent)", { silent = true })

kmap("", "]q", "<Plug>(IndentWiseNextLesserIndent)", { silent = true })
kmap("", "]w", "<Plug>(IndentWiseNextEqualIndent)", { silent = true })
kmap("", "]e", "<Plug>(IndentWiseNextGreaterIndent)", { silent = true })

kmap("", "[_", "<Plug>(IndentWisePreviousAbsoluteIndent)", { silent = true })
kmap("", "]_", "<Plug>(IndentWiseNextAbsoluteIndent)", { silent = true })

kmap("", "[%", "<Plug>(IndentWiseBlockScopeBoundaryBegin)", { silent = true })
kmap("", "]%", "<Plug>(IndentWiseBlockScopeBoundaryEnd)", { silent = true })

-- Visual
kmap("v", "<", "<gv", opts)
kmap("v", ">", ">gv", opts)

-- Move selection up/down
kmap("v", "<S-j>", ":m '>+1<CR>gv=gv", opts)
kmap("v", "<S-k>", ":m '<-2<CR>gv=gv", opts)

-- paste without copying selection
kmap("v", "p", '"_dP', opts)

-- Nvim tree
kmap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- Telescope
local telescope_ok, telescope = pcall(require, "telescope")
if telescope_ok then
    kmap("n", "<leader>pp", "<cmd>Telescope find_files<cr>", opts)
    kmap("n", "<leader>pg", "<cmd>Telescope live_grep<cr>", opts)
    kmap("n", "<leader>ps", "<cmd>Telescope lsp_document_symbols<cr>", opts)
    kmap("n", "<leader>po", "<cmd>Telescope project project<cr>", opts)
    kmap("n", "<A-tab>", "<cmd>Telescope buffers<cr>", opts)

    -- Harpoon
    local hp, harpoon = pcall(require, "harpoon.ui")
    if hp then
        kmap("n", "<leader>h", function()
            telescope.extensions.harpoon.marks(require('telescope.themes').get_dropdown{
                previewer = false, initial_mode='normal', prompt_title='Harpoon'
            })
        end, opts)
        kmap("n", "mm", require("harpoon.mark").add_file, opts)
        kmap("n", "<A-q>", function() harpoon.nav_file(1) end, opts)
        kmap("n", "<A-w>", function() harpoon.nav_file(2) end, opts)
        kmap("n", "<A-e>", function() harpoon.nav_file(3) end, opts)
        kmap("n", "<A-r>", function() harpoon.nav_file(4) end, opts)
    end
end

--[[ kmap("n", "<A-l>", require("harpoon.ui").nav_next, opts) ]]
--[[ kmap("n", "<A-h>", require("harpoon.ui").nav_next, opts) ]]
kmap("n", "<A-h>", "<plug>(CybuPrev)", opts)
kmap("n", "<A-l>", "<plug>(CybuNext)", opts)

-- Git
kmap("n", "<leader>gs", ":G<cr>", opts)
kmap("n", "<leader>gf", ":diffget //2 | diffupdate<cr>", opts)
kmap("n", "<leader>gj", ":diffget //3 | diffupdate<cr>", opts)

-- Undo tree
kmap("n", "<leader>u", ":UndotreeShow<cr>", opts)

-- Toggle Term
kmap({ "n", "t" }, "<C-t>p", "<cmd>lua _PYTHON_TOGGLE()<cr>", opts)

-- Copilot
kmap("i", "<C-q><C-q>", "<C-o>:Copilot disable<cr>", opts)
kmap("i", "<C-q><C-e>", "<C-o>:Copilot enable<cr>", opts)
kmap("i", "<Plug>(vimrc:copilot-dummy-map)", "copilot#Accept(\"\\<CR>\")", { noremap = false, silent = true, script = true, expr = true })
vim.g.copilot_no_tab_map = true

-- Dial
local dial_ok, dial = pcall(require, "dial.map")
if dial_ok then
    kmap({ "n", "v" }, "<C-a>", dial.inc_normal(), { noremap = true })
    kmap({ "n", "v" }, "<C-x>", dial.dec_normal(), { noremap = true })
    kmap("v", "g<C-a>", dial.inc_gvisual(), { noremap = true })
    kmap("v", "g<C-x>", dial.dec_gvisual(), { noremap = false })
end


-- Run
local acr_ok, acr = pcall(require, "acr")
if acr_ok then
    kmap("n", "<leader>t", acr.ACRAuto, opts)
    kmap("n", "<F1>",      acr.ACRAuto, opts)
    kmap("n", "<leader>r", acr.ACR, opts)
    kmap("n", "<F2>",      acr.ACR, opts)
end

-- Debugging
local dap_ok, dap = pcall(require, "dap")
local dui_ok, dapui = pcall(require, "dapui")
if dap_ok and dui_ok then
    kmap("n", "<leader>db", dap.toggle_breakpoint, opts)
    kmap("n", "<F9>", dap.toggle_breakpoint, opts)
    kmap("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint Condition: ")) end, opts)
    kmap("n", "<leader>dc", dap.continue, opts)
    kmap("n", "<F5>", dap.continue, opts)
    kmap("n", "<leader>do", dap.step_over, opts)
    kmap("n", "<F6>", dap.step_over, opts)
    kmap("n", "<leader>di", dap.step_into, opts)
    kmap("n", "<F7>", dap.step_into, opts)
    kmap("n", "<leader>dO", dap.step_out, opts)
    kmap("n", "<F19>", dap.step_out, opts)
    kmap("n", "<leader>dr", dap.repl.toggle, opts)
    kmap("n", "<leader>dl", dap.run_last, opts)
    kmap("n", "<leader>du", dapui.toggle, opts)
    kmap("n", "<leader>dt", dap.terminate, opts)
    kmap("n", "<F8>", dap.terminate, opts)
    kmap("n", "<leader>de", dapui.eval, opts)
    kmap("n", "<leader>dj", function() require("dap.ext.vscode").load_launchjs(vim.fn.getcwd() .. "/launch.json") end, opts)
end

local jdtls_ok, jdtls = pcall(require, "jdtls")
if jdtls_ok and d then
    kmap("n", "<leader>dl", jdtls.test_nearest_class, opts)
    kmap("n", "<leader>dm", jdtls.test_nearest_method, opts)
end
