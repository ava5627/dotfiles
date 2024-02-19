local home = vim.fn.expand("~")
-- Automatically install lazy.nvim if not found
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.notify("Installing lazy.nvim", vim.log.levels.INFO)
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
    vim.notify("Missing lazy.nvim", vim.log.levels.ERROR)
    return
end

-- Install your plugins here
lazy.setup({
    -- Dependencies
    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",
    { "kyazdani42/nvim-web-devicons", config = true },
    { import = "plugins" },

    {
        "zbirenbaum/copilot.lua",
        cond = vim.fn.has("mac") == 0,
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = {
                auto_trigger = true,
                keymap = {
                    accept = "<C-f>",
                    accept_word = "<A-f>",
                    accept_line = false,
                    next = "<A-]>",
                    prev = "<A-[>",
                    dismiss = "<C-]>",
                },
            },
            filetypes = {
                ["*"] = true,
            },
        },
    },
    "f3fora/cmp-spell",
    "rafamadriz/friendly-snippets",
    {
        "williamboman/mason.nvim",
        opts = { ui = { border = "rounded" } }
    },
    { "williamboman/mason-lspconfig.nvim", config = true },
    {
        "ray-x/lsp_signature.nvim",
        opts = {
            floating_window = false,
            hint_enable = true, -- virtual hint enable
            hint_prefix = "󰏫 ", -- Pencil for parameter
            hint_scheme = "String",
            hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
        }
    },
    { 'j-hui/fidget.nvim',                 config = true },
    { "lvimuser/lsp-inlayhints.nvim",      config = true },
    {
        "folke/neodev.nvim",
        ft = "lua",
        opts = {
            library = { plugins = { "nvim-dap-ui" }, types = true },
            override = function(_, library)
                library.enabled = true
                library.plugins = true
            end
        }
    },
    { 'mrcjkb/rustaceanvim', ft = 'rust' },
    {
        "windwp/nvim-autopairs",
        opts = {
            check_ts = true,
            fast_wrap = {
                end_key = "g",
                keys = "asdfjkleiwo",
            },
        }
    },
    {
        "mbbill/undotree",
        keys = {
            { "<leader>u", ":UndotreeToggle<CR>", desc = "Undo tree" }
        }
    },
    "nvim-lualine/lualine.nvim",
    { "SmiteshP/nvim-navic", opts = { highlight = true } },
    {
        "famiu/bufdelete.nvim",
        keys = {
            { "<leader>q", ":Bdelete<CR>",       desc = "Delete buffer" },
            { "<leader>f", ":Bdelete force<CR>", desc = "Force delete buffer" },
        }
    },
    {
        "ghillb/cybu.nvim",
        opts = {
            position = {
                anchor = "topright",
                vertical_offset = 5,
                horizontal_offset = 5,
            },
            exclude = { "NvimTree" },
        },
        keys = {
            { "<A-h>", function() require('cybu').cycle("prev") end, desc = "Previous buffer" },
            { "<A-l>", function() require('cybu').cycle("next") end, desc = "Next buffer" },
        }
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = { scope = { enabled = false } },
    },
    "stevearc/dressing.nvim",
    {
        "rcarriga/nvim-notify",
        config = function(_, opts)
            require("notify").setup(opts)
            vim.notify = require("notify")
        end,
        opts = { render = "compact", max_height = 10, max_width = 100, timeout = 500 },
    },
    { "folke/which-key.nvim",        config = true },
    "tpope/vim-surround",
    {
        "monaqa/dial.nvim",
        config = function()
            local augend = require("dial.augend")
            require("dial.config").augends:register_group {
                default = {
                    augend.integer.alias.decimal_int,
                    augend.integer.alias.hex,
                    augend.constant.alias.bool,
                    augend.constant.new { elements = { "True", "False" } },
                    augend.constant.new { elements = { "Yes", "No" } },
                    augend.constant.new { elements = { "yes", "no" } },
                },
            }
        end,
        keys = function()
            return {
                { "<C-a>",  require("dial.map").inc_normal(),  desc = "Dial up" },
                { "<C-x>",  require("dial.map").dec_normal(),  desc = "Dial down" },
                { "g<C-a>", require("dial.map").inc_gvisual(), desc = "Dial up",   mode = "v" },
                { "g<C-x>", require("dial.map").dec_gvisual(), desc = "Dial down", mode = "v" },
                { "<C-a>",  require("dial.map").inc_visual(),  desc = "Dial up",   mode = "v" },
                { "<C-x>",  require("dial.map").dec_visual(),  desc = "Dial down", mode = "v" },
            }
        end
    },
    "tpope/vim-repeat",
    { "norcalli/nvim-colorizer.lua", config = true },
    {
        "lervag/vimtex",
        config = function()
            vim.g.vimtex_view_method = "zathura"
            vim.api.nvim_create_autocmd({ "User" }, {
                pattern = "VimtexEventQuit",
                command = "VimtexClean"
            })
        end,
        ft = "tex",
    },
    { "numToStr/Comment.nvim",    config = true },
    { "folke/todo-comments.nvim", config = true },
    {
        "ava5627/ACR.nvim",
        dir = "~/repos/ACR",
        dev = vim.loop.fs_stat(home .. "/repos/ACR") ~= nil,
        main = "acr",
        opts = {
            term_opts = {
                direction = "horizontal",
                on_open = function()
                    require("nvim-tree.api").tree.toggle({ focus = false })
                    require("nvim-tree.api").tree.toggle({ focus = false })
                end
            }
        },
        keys = {
            { "<F1>", function() require("acr").ACRLast() end, desc = "Run Last" },
            { "<F2>", function() require("acr").ACR() end,     desc = "Run Choose" },
            { "<F3>", function() require("acr").ACRAuto() end, desc = "Run default" },
        },
        dependencies = {
            "akinsho/toggleterm.nvim",
        }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        main = "nvim-treesitter.configs",
        opts = {
            ensure_installed = "all",
            autopairs = { enable = true, },
            highlight = { enable = true, },
            indent = { enable = true, },
        }
    },
    "JoosepAlviste/nvim-ts-context-commentstring",
    "nvim-treesitter/nvim-treesitter-refactor",
    "nvim-treesitter/playground",
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
            },
        }
    },
    {
        "tpope/vim-fugitive",
        keys = {
            { "<leader>gs", ":G<CR>",                        desc = "Git status" },
            { "<leader>gp", ":G push<CR>",                   desc = "Git push" },
            { "<leader>gv", ":Gvdiffsplit\\!<CR>",           desc = "Git vdiffsplit" },
            { "<leader>gj", ":diffget //2 | diffupdate<CR>", desc = "Choose left" },
            { "<leader>gk", ":diffget //3 | diffupdate<CR>", desc = "Choose right" },
        }
    },
}, {
    dev = {
        path = "~/repos"
    }
})
