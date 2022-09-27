---@diagnostic disable: missing-parameter
local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    vim.notify("Installing packer close and reopen Neovim...")
    vim.cmd [[packadd packer.nvim]]
end


local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

augroup('packer_user_config', {})
autocmd('BufWritePost',{
    group = 'packer_user_config',
    pattern = 'plugins.lua',
    command = 'source <afile> | PackerSync'
})

local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

-- Install your plugins here
return packer.startup(function(use)
    -- Dependencies
    use("wbthomason/packer.nvim")
    use("nvim-lua/plenary.nvim")
    use("nvim-lua/popup.nvim")
    use({
        "kyazdani42/nvim-web-devicons",
        config = function() require('nvim-web-devicons').setup() end,
    })

    --cmp
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-cmdline")
    use("saadparwaiz1/cmp_luasnip")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-nvim-lua")
    use({
        "tzachar/cmp-tabnine",
        run="./install.sh",
        requires = "hrsh7th/nvim-cmp"
    })
    use({
        "github/copilot.vim",
        config = function() vim.g.copilot_filetypes = {["dap-repl"]=false} end,
    })
    use("f3fora/cmp-spell")

    -- snippets
    use("L3MON4D3/LuaSnip")
    use({
        "SirVer/ultisnips",
        config = function()
            vim.g.UltiSnipsExpandTrigger = '<C-l>'
            vim.g.UltiSnipsJumpForwardTrigger = '<C-l>'
            vim.g.UltiSnipsJumpBackwardTrigger = '<C-h>'
            vim.g.UltiSnipsListSnippets = '<c-x><c-s>'
            vim.g.UltiSnipsRemoveSelectModeMappings = 0
            vim.g.UltiSnipsSnippetDirectories={vim.fn.expand("$XDG_CONFIG_HOME/nvim/UltiSnips/"), "UltiSnips"}
        end
    })
    use("rafamadriz/friendly-snippets")
    use("quangnguyen30192/cmp-nvim-ultisnips")


    --lsp
    use("neovim/nvim-lspconfig")
    use("williamboman/mason.nvim")
    use("williamboman/mason-lspconfig.nvim")
    use("ray-x/lsp_signature.nvim")
    use("jose-elias-alvarez/null-ls.nvim") -- for formatters and linters
    use({
        'j-hui/fidget.nvim',
        config = function() require('fidget').setup() end,
    })

    -- Java
    use("mfussenegger/nvim-jdtls")

    -- Lua
    use("folke/lua-dev.nvim")


    -- colorschemes
    use("ellisonleao/gruvbox.nvim")
    use("lunarvim/darkplus.nvim")
    use("sainnhe/sonokai")
    use("folke/tokyonight.nvim")

    -- utility
    use("windwp/nvim-autopairs")
    use("mbbill/undotree")
    use("gpanders/editorconfig.nvim")
    use("nvim-lualine/lualine.nvim")
    use("akinsho/bufferline.nvim")
    use("moll/vim-bbye")
    use({
        "ghillb/cybu.nvim",
    })
    use("antoinemadec/FixCursorHold.nvim")
    use("lukas-reineke/indent-blankline.nvim")
    --[[ use("tpope/vim-sleuth") ]]
    use("ChristianChiarulli/harpoon")
    use("stevearc/dressing.nvim")
    use({
        "rcarriga/nvim-notify",
        config = function() vim.notify = require("notify") end,
    })

    -- movement
    use("tpope/vim-surround")
    use("jeetsukumaran/vim-indentwise")
    use("karb94/neoscroll.nvim")
    use("monaqa/dial.nvim")
    use("tpope/vim-repeat")

    -- highlighting
    use({
        "norcalli/nvim-colorizer.lua",
        config = function() require'colorizer'.setup() end,
    })
    use({ "Fymyte/rasi.vim", ft = "rasi" })

    use({
        "lervag/vimtex",
        config = function () vim.g.vimtex_view_method = "zathura" end,
    })
    -- use({
    --     "neomake/neomake",
    --     -- ft = "tex"
    -- })

    -- Comments
    use("numToStr/Comment.nvim")
    use("folke/todo-comments.nvim")


    -- Code Running/Debugging
    use("mfussenegger/nvim-dap")
    use("rcarriga/nvim-dap-ui")
    use("ravenxrz/DAPInstall.nvim")
    use("theHamsta/nvim-dap-virtual-text")

    -- Toggle Term
    use({ "akinsho/toggleterm.nvim", branch = "main" })

    -- nvim-tree
    use("kyazdani42/nvim-tree.lua")
    -- use({
    --   "yamatsum/nvim-nonicons",
    --   requires = {"kyazdani42/nvim-web-devicons"}
    -- })

    --Telescope
    use("nvim-telescope/telescope.nvim")
    use("nvim-telescope/telescope-project.nvim")

    --Treesitter
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    })
    use("JoosepAlviste/nvim-ts-context-commentstring")
    use("nvim-treesitter/nvim-treesitter-refactor")
    use("nvim-treesitter/playground")
    use("p00f/nvim-ts-rainbow")

    -- git
    use("lewis6991/gitsigns.nvim")
    use("tpope/vim-fugitive")

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
