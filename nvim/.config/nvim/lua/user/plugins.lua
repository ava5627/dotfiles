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

    --cmp
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
        cond = vim.fn.has("mac") == 0,
        dependencies = "hrsh7th/nvim-cmp"
    },
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

    -- snippets
    { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
    "rafamadriz/friendly-snippets",

    --lsp
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "ray-x/lsp_signature.nvim",
    { 'j-hui/fidget.nvim', config = true },
    { "lvimuser/lsp-inlayhints.nvim", config = true },

    -- Lua
    "folke/neodev.nvim",

    -- Rust
    {
        'mrcjkb/rustaceanvim',
        ft = { 'rust' },
    },


    -- colorschemes
    "ellisonleao/gruvbox.nvim",
    "lunarvim/darkplus.nvim",
    "sainnhe/sonokai",
    { "folke/tokyonight.nvim", lazy = false, priority = 1000 },

    -- utility
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
    "mbbill/undotree",
    "nvim-lualine/lualine.nvim",
    {
        "SmiteshP/nvim-navic",
        opts = { highlight = true }
    },
    -- "akinsho/bufferline.nvim",
    "famiu/bufdelete.nvim",
    "ghillb/cybu.nvim",
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = { scope = { enabled = false } },
    },
    --[[ use("tpope/vim-sleuth") ]]
    "ThePrimeagen/harpoon",
    "stevearc/dressing.nvim",
    {
        "rcarriga/nvim-notify",
        config = function(_, opts)
            local n = require("notify")
            n.setup(opts)
            vim.notify = n
        end,
        opts = { render = "compact", max_height = 10, max_width = 100, timeout = 500 },
    },
    { "folke/which-key.nvim", config = true },

    -- movement
    "tpope/vim-surround",
    "karb94/neoscroll.nvim",
    "monaqa/dial.nvim",
    "tpope/vim-repeat",

    -- highlighting
    { "norcalli/nvim-colorizer.lua", config = true },

    { "lervag/vimtex", config = function() vim.g.vimtex_view_method = "zathura" end, },

    -- Comments
    { "numToStr/Comment.nvim", config = true },
    { "folke/todo-comments.nvim", config = true },

    -- Code Running/Debugging
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "ravenxrz/DAPInstall.nvim",
    "theHamsta/nvim-dap-virtual-text",

    {
        "ava5627/acr.nvim",
        dir = "~/repos/ACR",
        dev = vim.loop.fs_stat("~/repos/ACR") ~= nil,
    },

    -- Toggle Term
    "akinsho/toggleterm.nvim",

    -- nvim-tree
    "kyazdani42/nvim-tree.lua",

    --Telescope
    { "nvim-telescope/telescope.nvim", branch = "0.1.x" },
    "nvim-telescope/telescope-project.nvim",

    --Treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", },
    "JoosepAlviste/nvim-ts-context-commentstring",
    "nvim-treesitter/nvim-treesitter-refactor",
    "nvim-treesitter/playground",
    -- "p00f/nvim-ts-rainbow",

    -- git
    "lewis6991/gitsigns.nvim",
    "tpope/vim-fugitive",

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
})
