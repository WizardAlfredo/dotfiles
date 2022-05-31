local fn = vim.fn

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
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

return require("packer").startup(function(use)
    -- General
    use "wbthomason/packer.nvim"
    use "nvim-lua/popup.nvim"
    use "nvim-lua/plenary.nvim"

    use "kyazdani42/nvim-web-devicons"

    -- Colorscheme
    use "WizardAlfredo/nvim-htb-lua"

    -- NvimTree
    use "kyazdani42/nvim-tree.lua"
    use { "nvim-treesitter/nvim-treesitter", run = ':TSUpdate' }

    -- Other
    use "max397574/better-escape.nvim" -- for jk better escape
    use "moll/vim-bbye"
    use "windwp/nvim-autopairs" -- ()
    use "akinsho/bufferline.nvim" -- change the config

    -- Completions
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "saadparwaiz1/cmp_luasnip"
    use "hrsh7th/cmp-nvim-lsp"

    -- Snipets
    use "L3MON4D3/LuaSnip"
    use "rafamadriz/friendly-snippets"

    -- LSP
    use { "neovim/nvim-lspconfig" }
    use { "williamboman/nvim-lsp-installer" }
    use { "tamago324/nlsp-settings.nvim" }
    use { "jose-elias-alvarez/null-ls.nvim" }
    use { "lukas-reineke/indent-blankline.nvim" }
    use { "ahmedkhalf/project.nvim" }

    -- Comments
    use { "JoosepAlviste/nvim-ts-context-commentstring" }
    use { "numToStr/Comment.nvim" }

    -- Telescope
    use { "nvim-telescope/telescope.nvim" }
    use { "nvim-telescope/telescope-fzf-native.nvim",
        requires = { "nvim-telescope/telescope.nvim" },
        run = "make"
    }

    -- More Speed
    use { "lewis6991/impatient.nvim" }

    -- Markdown
    use { "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        ft  = "markdown",
    }

    -- Git
    use { "lewis6991/gitsigns.nvim" }

    -- Diagnostics
    -- use { "antoinemadec/FixCursorHold.nvim" }
    use { "folke/which-key.nvim" }

    -- CSS colors
    use { "norcalli/nvim-colorizer.lua" }

   if PACKER_BOOTSTRAP then
       require("packer").sync()
   end
end)
