local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
require("lazy").setup({
    -- colorschema
    'cocopon/iceberg.vim',
    -- LSP
    {
        'neoclide/coc.nvim',
        branch = 'release'
    },
    -- log highlight
    'mtdl9/vim-log-highlighting',
    'tpope/vim-commentary',
    'tpope/vim-rails',
    -- file icons
    -- 'nvim-tree/nvim-web-devicons',
    -- using packer.nvim
    {
        'akinsho/bufferline.nvim',
        tag = "v3.3.0",
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
        event = 'BufRead'
    },
    -- filer plugin
    -- { 'lambdalisue/fern.vim',                        },
    -- { 'lambdalisue/fern-renderer-nerdfont.vim',      dependencies = { 'lambdalisue/fern.vim' }},
    -- { 'lambdalisue/nerdfont.vim',                    dependencies = 'lambdalisue/fern.vim'},
    -- ecosystem to develop with deno
    {
        'vim-denops/denops.vim',
        lazy = false
    },
    -- syntaxhilight
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = 'BufRead'
    },
    -- treesitter plugin
    {
        'windwp/nvim-ts-autotag',
        dependencies = 'nvim-treesitter/nvim-treesitter',
        event = 'BufRead'
    },
    -- A Neovim plugin for setting the commentstring option based on the cursor location in the file. The location is checked via treesitter queries.
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        dependencies = 'nvim-treesitter/nvim-treesitter',
        event = 'BufRead'
    },

    {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end,
        event = 'ModeChanged'
    },
    -- color preview
    {
        'norcalli/nvim-colorizer.lua',
        event = 'BufRead'
    },
    -- surroundings operator, textobject
    {
        'machakann/vim-sandwich',
        event = 'ModeChanged'
    },
    -- to camelcase or snakecase etc...
    'nicwest/vim-camelsnek',
    -- quickrun
    'thinca/vim-quickrun',
    -- async quickrun
    {
        'Shougo/vimproc.vim',
        run = 'make'
    },
    -- quickrun plugin
    {
        'osyo-manga/shabadou.vim',
        dependencies = 'thinca/vim-quickrun'
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    -- {'iamcco/markdown-preview.nvim', run = 'sh -c "cd app && yarn install"'},
    -- markfown preview
    {
        'toppair/peek.nvim',
        run = 'deno task --quiet build:fast'
    },
    'akinsho/toggleterm.nvim',
    -- git plugin
    { 'lewis6991/gitsigns.nvim' },
    -- common utilities
    'nvim-lua/plenary.nvim',
    {
        'sindrets/diffview.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        cmd = 'DiffviewFileHistory *'
    },
    -- statusline
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    },
    {
        'mvllow/modes.nvim',
        tag = 'v0.2.1',
        config = function()
            require('modes').setup()
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {}
    },
    { 'github/copilot.vim' },
    {
        'TimUntersberger/neogit',
        dependencies = 'nvim-lua/plenary.nvim'
    },
    {
        'lambdalisue/kensaku.vim',
        dependencies = 'vim-denops/denops.vim'
    },
    {
        'lambdalisue/gin.vim',
        dependencies = 'vim-denops/denops.vim'
    },
    {
        'yuki-yano/fuzzy-motion.vim',
        dependencies = 'vim-denops/denops.vim'
    },
    {
        'akinsho/git-conflict.nvim',
        version = '*',
        config = true
    },
    { 'ruanyl/vim-gh-line' },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    }
})
