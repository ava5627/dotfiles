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
    use "wbthomason/packer.nvim" -- Have packer manage itself
    use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins

    --cmp
    use "hrsh7th/nvim-cmp" -- The completion plugin
    use "hrsh7th/cmp-buffer" -- buffer completions
    use "hrsh7th/cmp-path" -- path completions
    use "hrsh7th/cmp-cmdline" -- cmdline completions
    use "saadparwaiz1/cmp_luasnip" -- snippet completions
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lua"
 	use {
        'tzachar/cmp-tabnine',
        run='./install.sh',
        requires = 'hrsh7th/nvim-cmp'
    }
    use "f3fora/cmp-spell"

    -- snippets
    use "L3MON4D3/LuaSnip" --snippet engine
    use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

    --lsp
    use "neovim/nvim-lspconfig"
    use "williamboman/nvim-lsp-installer"
    use "jose-elias-alvarez/null-ls.nvim"


    -- colorschemes
    use "ellisonleao/gruvbox.nvim"
    use "lunarvim/darkplus.nvim"

    -- utility
    use "norcalli/nvim-colorizer.lua"
    use "windwp/nvim-autopairs"
    use "tpope/vim-surround"
    use "nvim-lualine/lualine.nvim"
    use "numToStr/Comment.nvim" -- Easily comment stuff
    use {
      'yamatsum/nvim-nonicons',
      requires = {'kyazdani42/nvim-web-devicons'}
    }
    -- nvim-tree
    use "kyazdani42/nvim-tree.lua"


    --Telescope
    use "nvim-telescope/telescope.nvim"

    --Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    }
    use 'JoosepAlviste/nvim-ts-context-commentstring'

    -- git
    use "lewis6991/gitsigns.nvim"


    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
