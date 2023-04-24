

local function opts(desc)
    return {desc = desc, noremap = true, silent = true }
end

local kmap = vim.keymap.set

kmap("", "<Space>", "<Nop>", opts("Noop"))
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Misc
kmap("n", "<leader>ww", ":w<cr>", opts("Save"))
kmap("n", "<leader>wq", ":bdelete<cr>", opts("Save and close buffer"))
kmap("n", "<leader>q", ":Bdelete<cr>", opts("Close buffer"))
kmap("n", "<leader>fq", ":Bdelete!<cr>", opts("Force close buffer"))

-- Clear search highlights
kmap("n", "<A-a>", ":nohl<cr>", opts("Clear search highlights"))

-- Insert line above/below without leaving normal mode
kmap("n", "<a-i>", "moO<esc>`o", opts("Insert line above"))
kmap("n", "<a-o>", "moo<esc>`o", opts("Insert line below"))

-- Better window navigation
kmap("n", "<C-h>", "<C-w>h", opts("Window left"))
kmap("n", "<C-j>", "<C-w>j", opts("Window down"))
kmap("n", "<C-k>", "<C-w>k", opts("Window up"))
kmap("n", "<C-l>", "<C-w>l", opts("Window right"))
kmap("n", "<C-q>", "<C-w>q", opts("Close window"))
kmap("n", "<A-q>", ":bdelete<cr>", opts("Close buffer"))

-- Switch Buffers
-- kmap("n", "<A-l>", ":BufferLineCycleNext<CR>", opts("Next buffer"))
-- kmap("n", "<A-h>", ":BufferLineCyclePrev<CR>", opts("Previous buffer"))


-- Quick fix list
kmap("n", "<leader>co", ":copen<cr><C-w>p", opts("Open quickfix list"))
kmap("n", "<leader>cc", ":cclose<cr>", opts("Close quickfix list"))
kmap("n", "<leader>cn", ":cnext<cr>", opts("Next quickfix item"))
kmap("n", "<leader>cp", ":cprev<cr>", opts("Previous quickfix item"))

-- Resize windows with arrow keys
kmap("n", "<A-Up>", ":resize +5<cr>", opts("Resize window up"))
kmap("n", "<A-Down>", ":resize -5<cr>", opts("Resize window down"))
kmap("n", "<A-Left>", ":vertical resize +5<cr>", opts("Resize window left"))
kmap("n", "<A-Right>", ":vertical resize -5<cr>", opts("Resize window right"))

-- Open/Close windows
kmap("n", "<leader>v", "<C-w>v", opts("Open vertical split"))
kmap("n", "<leader>s", "<C-w>s", opts("Open horizontal split"))

-- Insert Mode
kmap("i", "<A-h>", "<left>", opts("Move cursor left"))
kmap("i", "<A-j>", "<down>", opts("Move cursor down"))
kmap("i", "<A-k>", "<up>", opts("Move cursor up"))
kmap("i", "<A-l>", "<right>", opts("Move cursor right"))

-- kmap("i", ":w", "<ESC>:w<cr>", opts("Save"))

-- Delete backwards
kmap("i", "<A-d>", "<C-o>dw", opts("Delete word"))
kmap("i", "<A-w>", "<delete>", opts("Delete character"))

-- Paste in insert mode
kmap("i", "<C-p>", "<left><C-o>p", opts("Paste"))

-- Indent Jump
kmap("", "[q", "<Plug>(IndentWisePreviousLesserIndent)", { silent = true, desc = "Indent jump" })
kmap("", "[w", "<Plug>(IndentWisePreviousEqualIndent)", { silent = true, desc = "Indent jump" })
kmap("", "[e", "<Plug>(IndentWisePreviousGreaterIndent)", { silent = true, desc = "Indent jump" })

kmap("", "]q", "<Plug>(IndentWiseNextLesserIndent)", { silent = true, desc = "Indent jump" })
kmap("", "]w", "<Plug>(IndentWiseNextEqualIndent)", { silent = true, desc = "Indent jump" })
kmap("", "]e", "<Plug>(IndentWiseNextGreaterIndent)", { silent = true, desc = "Indent jump" })

kmap("", "[_", "<Plug>(IndentWisePreviousAbsoluteIndent)", { silent = true, desc = "Indent jump" })
kmap("", "]_", "<Plug>(IndentWiseNextAbsoluteIndent)", { silent = true, desc = "Indent jump" })

kmap("", "[%", "<Plug>(IndentWiseBlockScopeBoundaryBegin)", { silent = true, desc = "Indent jump" })
kmap("", "]%", "<Plug>(IndentWiseBlockScopeBoundaryEnd)", { silent = true, desc = "Indent jump" })

-- Visual
kmap("v", "<", "<gv", opts("Shift left"))
kmap("v", ">", ">gv", opts("Shift right"))

-- Move selection up/down
kmap("v", "<S-j>", ":m '>+1<CR>gv=gv", opts("Move selection down"))
kmap("v", "<S-k>", ":m '<-2<CR>gv=gv", opts("Move selection up"))

-- paste without copying selection
kmap("v", "p", '"_dP', opts("Paste"))

-- Nvim tree
local tree_ok, tree = pcall(require, "nvim-tree.api")
if not tree_ok then
    vim.notify("Nvim tree not found", vim.log.levels.ERROR)
else
    kmap("n", "<leader>e", function() tree.tree.toggle({ focus = false }) end, opts("Toggle file explorer"))
end

-- Telescope
local telescope_ok, telescope = pcall(require, "telescope")
if telescope_ok then
    kmap("n", "<leader>pp", "<cmd>Telescope find_files<cr>", opts("Find files"))
    kmap("n", "<leader>pg", "<cmd>Telescope live_grep<cr>", opts("Grep"))
    kmap("n", "<leader>ps", "<cmd>Telescope lsp_document_symbols<cr>", opts("Document symbols"))
    kmap("n", "<leader>po", "<cmd>Telescope project project<cr>", opts("Projects"))
    kmap("n", "<A-tab>", "<cmd>Telescope buffers<cr>", opts("Buffers"))

    -- Harpoon
    local hp, harpoon = pcall(require, "harpoon.ui")
    if hp then
        kmap("n", "<leader>h", function()
            telescope.extensions.harpoon.marks(require('telescope.themes').get_dropdown{
                previewer = false, initial_mode='normal', prompt_title='Harpoon'
            })
        end, opts("Harpoon marks"))
        kmap("n", "mm", require("harpoon.mark").add_file, opts("Add file to harpoon"))
        kmap("n", "<A-1>", function() harpoon.nav_file(1) end, opts("Open harpoon 1"))
        kmap("n", "<A-2>", function() harpoon.nav_file(2) end, opts("Open harpoon 2"))
        kmap("n", "<A-3>", function() harpoon.nav_file(3) end, opts("Open harpoon 3"))
        kmap("n", "<A-4>", function() harpoon.nav_file(4) end, opts("Open harpoon 4"))
    end
end

--[[ kmap("n", "<A-l>", require("harpoon.ui").nav_next, opts) ]]
--[[ kmap("n", "<A-h>", require("harpoon.ui").nav_next, opts) ]]
kmap("n", "<A-h>", "<plug>(CybuPrev)", opts("Previous buffer"))
kmap("n", "<A-l>", "<plug>(CybuNext)", opts("Next buffer"))

-- Git
kmap("n", "<leader>gs", ":G<cr>", opts("Open git menu"))
kmap("n", "<leader>gp", ":Git push<cr>", opts("Git push"))
kmap("n", "<leader>gv", ":Gvdiffsplit\\!<cr>", opts("Git vdiffsplit"))
kmap("n", "<leader>gj", ":diffget //2 | diffupdate<cr>", opts("Choose left"))
kmap("n", "<leader>gk", ":diffget //3 | diffupdate<cr>", opts("Choose right"))

-- Undo tree
kmap("n", "<leader>u", ":UndotreeShow<cr>", opts("Undo tree"))

-- Toggle Term
kmap({ "n", "t" }, "<C-t>p", "<cmd>lua _PYTHON_TOGGLE()<cr>", opts("Toggle python terminal"))

-- Copilot
kmap("i", "<C-q><C-q>", "<C-o>:Copilot disable<cr>", opts("Disable copilot"))
kmap("i", "<C-q><C-e>", "<C-o>:Copilot enable<cr>", opts("Enable copilot"))
-- kmap("i", "<Plug>(vimrc:copilot-dummy-map)", "copilot#Accept(\"\\<CR>\")", { noremap = false, silent = true, script = true, expr = true })
kmap("i", "<C-a>", "copilot#Accept(\"\\<CR>\")", { noremap = false, silent = true, script = true, expr = true, replace_keycodes = false, desc = "Copilot accept"})
vim.g.copilot_no_tab_map = true

-- Dial
local dial_ok, dial = pcall(require, "dial.map")
if dial_ok then
    kmap({ "n", "v" }, "<C-a>", dial.inc_normal(), { noremap = true, desc = "Dial up" })
    kmap({ "n", "v" }, "<C-x>", dial.dec_normal(), { noremap = true, desc = "Dial down" })
    kmap("v", "g<C-a>", dial.inc_gvisual(), { noremap = true, desc = "Dial up" })
    kmap("v", "g<C-x>", dial.dec_gvisual(), { noremap = false, desc = "Dial down" })
end


-- Run
local acr_ok, acr = pcall(require, "acr")
if acr_ok then
    kmap("n", "<leader>t", acr.ACRAuto, opts("Run default"))
    kmap("n", "<F1>",      acr.ACRAuto, opts("Run default"))
    kmap("n", "<leader>r", acr.ACR, opts("Run Choose"))
    kmap("n", "<F2>",      acr.ACR, opts("Run Choose"))
end

-- Debugging
local dap_ok, dap = pcall(require, "dap")
local dui_ok, dapui = pcall(require, "dapui")
if dap_ok and dui_ok then
    kmap("n", "<leader>db", dap.toggle_breakpoint, opts("Toggle breakpoint"))
    kmap("n", "<F9>", dap.toggle_breakpoint, opts("Toggle breakpoint"))
    kmap("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint Condition: ")) end, opts("Set breakpoint"))
    kmap("n", "<leader>dc", dap.continue, opts("Continue"))
    kmap("n", "<F5>", dap.continue, opts("Continue"))
    kmap("n", "<leader>do", dap.step_over, opts("Step over"))
    kmap("n", "<F6>", dap.step_over, opts("Step over"))
    kmap("n", "<leader>di", dap.step_into, opts("Step into"))
    kmap("n", "<F7>", dap.step_into, opts("Step into"))
    kmap("n", "<leader>dO", dap.step_out, opts("Step out"))
    kmap("n", "<F19>", dap.step_out, opts("Step out"))
    kmap("n", "<leader>dr", dap.repl.toggle, opts("Toggle repl"))
    kmap("n", "<leader>dl", dap.run_last, opts("Run last"))
    kmap("n", "<leader>du", dapui.toggle, opts("Toggle UI"))
    kmap("n", "<leader>dt", dap.terminate, opts("Terminate"))
    kmap("n", "<F8>", dap.terminate, opts("Terminate"))
    kmap("n", "<leader>de", dapui.eval, opts("Eval"))
    kmap("n", "<leader>dj", function() require("dap.ext.vscode").load_launchjs(vim.fn.getcwd() .. "/launch.json") end, opts("Load launch.json"))
end
