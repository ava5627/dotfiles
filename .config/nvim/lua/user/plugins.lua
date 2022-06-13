local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

vim.cmd [[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]]

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
    -- My plugins here
    use "wbthomason/packer.nvim"
    use "nvim-lua/popup.nvim"
    use "nvim-lua/plenary.nvim"

    --cmp
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "saadparwaiz1/cmp_luasnip"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lua"
 	use {
        "tzachar/cmp-tabnine",
        run="./install.sh",
        requires = "hrsh7th/nvim-cmp"
    }
    use {
        "github/copilot.vim",
        commit = "573da1a"
    }
    use "f3fora/cmp-spell"

    -- snippets
    use "L3MON4D3/LuaSnip"
    use "rafamadriz/friendly-snippets"


    --lsp
    use "neovim/nvim-lspconfig"
    use "williamboman/nvim-lsp-installer"


    -- colorschemes
    use "ellisonleao/gruvbox.nvim"
    use "lunarvim/darkplus.nvim"
    use "sainnhe/sonokai"

    -- utility
    use "windwp/nvim-autopairs"
    use "numToStr/Comment.nvim"

    use "nvim-lualine/lualine.nvim"
    -- use "akinsho/bufferline.nvim"

    use "antoinemadec/FixCursorHold.nvim"
    use "lukas-reineke/indent-blankline.nvim"
    use "glepnir/dashboard-nvim"

    -- movement
    use "tpope/vim-surround"
    use "jeetsukumaran/vim-indentwise"
    use {
        "psliwka/vim-smoothie",
        config = function() vim.g.smoothie_speed_linear_factor=15 end
    }
    use "monaqa/dial.nvim"
    use "tpope/vim-repeat"

    -- highlighting
    use {
        "norcalli/nvim-colorizer.lua",
        config = function() require'colorizer'.setup() end,
    }
    use {
      "Fymyte/rasi.vim",
      ft = "rasi",
    }


    -- Code Running/Debugging
    -- use "puremourning/vimspector"
    use "mfussenegger/nvim-dap"
    use "Pocco81/DAPInstall.nvim"

    -- Toggle Term
    use {
        "akinsho/toggleterm.nvim",
        branch = "main"
    }

    -- nvim-tree
    use "kyazdani42/nvim-tree.lua"
    use {
        "kyazdani42/nvim-web-devicons",
        config = function() require'nvim-web-devicons'.setup() end,
    }
    -- use {
    --   "yamatsum/nvim-nonicons",
    --   requires = {"kyazdani42/nvim-web-devicons"}
    -- }

    --Telescope
    use "nvim-telescope/telescope.nvim"
    use "nvim-telescope/telescope-project.nvim"

    --Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    }
    use "JoosepAlviste/nvim-ts-context-commentstring"
    use "nvim-treesitter/nvim-treesitter-refactor"
    use "romgrk/nvim-treesitter-context"
    use "nvim-treesitter/playground"

    -- git
    use "lewis6991/gitsigns.nvim"
    use "tpope/vim-fugitive"

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
