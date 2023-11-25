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

vim.api.nvim_create_augroup("sync_lazy_config", {})
vim.api.nvim_create_autocmd(
    "BufWritePost", {
        group = "sync_lazy_config",
        pattern = "plugins.lua",
        command = "source <afile> | Lazy sync"
    }
)

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
    {
        "kyazdani42/nvim-web-devicons",
        config = function() require('nvim-web-devicons').setup() end,
    },

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
        requires = "hrsh7th/nvim-cmp"
    },
    {
        "github/copilot.vim",
        config = function() vim.g.copilot_filetypes = { ["dap-repl"] = false } end,
    },
    "f3fora/cmp-spell",

    -- snippets
    "L3MON4D3/LuaSnip",
    {
        "SirVer/ultisnips",
        config = function()
            vim.g.UltiSnipsExpandTrigger = '<C-l>'
            vim.g.UltiSnipsJumpForwardTrigger = '<C-l>'
            vim.g.UltiSnipsJumpBackwardTrigger = '<C-h>'
            vim.g.UltiSnipsListSnippets = '<c-x><c-s>'
            vim.g.UltiSnipsRemoveSelectModeMappings = 0
            vim.g.UltiSnipsSnippetDirectories = { vim.fn.expand("$XDG_CONFIG_HOME/nvim/UltiSnips/"), "UltiSnips" }
        end
    },
    "rafamadriz/friendly-snippets",
    "quangnguyen30192/cmp-nvim-ultisnips",


    --lsp
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "ray-x/lsp_signature.nvim",
    -- "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters,
    {
        'j-hui/fidget.nvim',
        tag = 'legacy',
        config = function() require('fidget').setup() end,
    },

    -- Lua
    "folke/neodev.nvim",

    -- Rust
    { "simrat39/rust-tools.nvim", lazy = true },


    -- colorschemes
    "ellisonleao/gruvbox.nvim",
    "lunarvim/darkplus.nvim",
    "sainnhe/sonokai",
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000
    },

    -- utility
    "windwp/nvim-autopairs",
    "mbbill/undotree",
    "nvim-lualine/lualine.nvim",
    "SmiteshP/nvim-navic",
    -- "akinsho/bufferline.nvim",
    "moll/vim-bbye",
    "ghillb/cybu.nvim",
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            local ibl = require("ibl")
            ibl.setup({ scope = { enabled = false } })
        end,
    },
    --[[ use("tpope/vim-sleuth") ]]
    "ThePrimeagen/harpoon",
    "stevearc/dressing.nvim",
    {
        "rcarriga/nvim-notify",
        config = function()
            local n = require("notify")
            n.setup({
                render = "compact",
                max_height = 10,
                max_width = 100,
                timeout = 500,
            })
            vim.notify = n
        end,
    },
    "folke/which-key.nvim",

    -- movement
    "tpope/vim-surround",
    "jeetsukumaran/vim-indentwise",
    "karb94/neoscroll.nvim",
    "monaqa/dial.nvim",
    "tpope/vim-repeat",

    -- highlighting
    {
        "norcalli/nvim-colorizer.lua",
        config = function() require 'colorizer'.setup() end,
    },

    {
        "lervag/vimtex",
        config = function() vim.g.vimtex_view_method = "zathura" end,
    },

    -- Comments
    "numToStr/Comment.nvim",
    "folke/todo-comments.nvim",


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
    { "akinsho/toggleterm.nvim",  branch = "main" },

    -- nvim-tree
    "kyazdani42/nvim-tree.lua",

    --Telescope
    { "nvim-telescope/telescope.nvim", branch = "0.1.x" },
    "nvim-telescope/telescope-project.nvim",

    --Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
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
