-- lazy.nvim config START
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
-- lazy.nvim config END

vim.cmd("colorscheme iceberg")

-- plugin config

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}

require 'nvim-treesitter.configs'.setup {
    -- ensure_installed = "all",
    ensure_installed = { "ruby", "css", "html", "javascript", "typescript", "python", "rust", "go", "sql", "yaml", "vue", "tsx", "terraform", "scss", "markdown", "lua", "vim", "bash", "json", "toml" },
    -- sync_install = false,
    -- auto_install = true,
    highlight = {
        enable = true,
        disable = {},
    },
    autotag = {
        enable = true,
    },
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
        -- disable slow treesitter highlight for large files
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
    },
    context_commentstring = {
        enable = true
    }
}

-- toggleterm
require('toggleterm').setup()
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
    cmd = "lazygit",
    direction = "float",
    hidden = true
})

function _lazygit_toggle()
    lazygit:toggle()
end

require('gitsigns').setup {
    signs                        = {
        -- add          = { text = '│' },
        -- change       = { text = '│' },
        -- delete       = { text = '_' },
        -- topdelete    = { text = '‾' },
        -- changedelete = { text = '~' },
        -- untracked    = { text = '┆' },
        add = { hl = 'GitSignsAdd', text = ' ▎', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
        change = { hl = 'GitSignsChange', text = ' ▎', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        delete = { hl = 'GitSignsDelete', text = ' ', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        topdelete = { hl = 'GitSignsDelete', text = ' ', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        changedelete = { hl = 'GitSignsChange', text = '▎ ', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    },
    signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`

    watch_gitdir                 = {
        follow_files = true
    },
    attach_to_untracked          = true,
    current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts      = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority                = 6,
    update_debounce              = 100,
    status_formatter             = nil, -- Use default
    max_file_length              = 40000, -- Disable if file is longer than this (in lines)
    preview_config               = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
    yadm                         = {
        enable = false
    },
    on_attach                    = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end, { expr = true })

        map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end, { expr = true })

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk)
        map('n', '<leader>hr', gs.reset_hunk)
        map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        map('n', '<leader>hS', gs.stage_buffer)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hR', gs.reset_buffer)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hb', function() gs.blame_line { full = true } end)
        map('n', '<leader>tb', gs.toggle_current_line_blame)
        map('n', '<leader>hd', gs.diffthis)
        map('n', '<leader>hD', function() gs.diffthis('~') end)
        map('n', '<leader>td', gs.toggle_deleted)

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
}

require("bufferline").setup {}

for k, v in pairs({
    --toggleterm
    ["<leader>lg"] = "<cmd>lua _lazygit_toggle()<CR>",
    -- bufferline
    ["<C-j>"] = ":BufferLineCycleNext<CR>",
    ["<C-k>"] = ":BufferLineCyclePrev<CR>",
    ["<C-c>"] = ":bdelete!<CR>",
}) do
    -- vim.api.nvim_set_keymap("n", k, v, {noremap = true, silent = true})
    vim.keymap.set("n", k, v)
end


-- fern.vim
-- vim.keymap.set("n", "<Leader>df", ":Fern . -drawer<CR>")
-- vim.g['fern#default_hidden'] = 1
-- vim.g['fern#renderer'] = 'nerdfont'
-- vim.g['fern#renderer#nerdfont#indent_markers'] = 1

-- vim-quickrun
vim.keymap.set("n", "<Leader>r", ":QuickRun<CR>")
-- vim.g['quickrun_config'] = {
--   "_" = {
--       "outputter" = "multi:buffer:quickfix",
--       "outputter/buffer/split" = ":botright 8px",
--       "runner" = "vimproc",
--       "runner/vimproc/updatetime" = 40,
--       "hook/close_quickfix/enable_hook_loaded" = 1,
--       "hook/close_quickfix/enable_success" = 1,
--       "hook/close_buffer/enable_failure" = 1,
--       "hook/close_buffer/enable_empty_data" = 1,
--       "hook/inu/enable" = 1,
--       "hook/inu/wait" = 20,
--   },
-- }

-- markdown preview
vim.keymap.set("n", "<Leader>md", ":MarkdownPreview<CR>")

require('colorizer').setup()
require("diffview").setup({})
vim.keymap.set('n', 'df', ':DiffviewOpen<CR>', {})
vim.keymap.set('n', 'fdf', ':DiffviewFileHistory %<CR>', {})
vim.keymap.set('n', 'cdf', ':DiffviewClose<CR>', {})

require('coc')

-- telescope.nvim
-------------------------------------------------------------------------------
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-l>'] = require('telescope.actions.layout').toggle_preview
            }
        },
        preview = {
            hide_on_startup = true -- hide previewer when picker starts
        }
    }
}
require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')
local builtin = require('telescope.builtin')

-- when a count N is given to a telescope mapping called through the following
-- function, the search is started in the Nth parent directory
local function telescope_cwd(picker, args)
    builtin[picker](vim.tbl_extend("error", args or {}, { cwd = ("../"):rep(vim.v.count) .. "." }))
end

local map, opts = vim.keymap.set, { noremap = true, silent = true }
map("n", "<leader>ff", function() telescope_cwd('find_files', { hidden = true }) end, opts)
map("n", "<leader>gr", function() telescope_cwd('live_grep') end, opts)
map("n", "<leader>ds", builtin.lsp_document_symbols, opts)
map("n", "<leader>ws", builtin.lsp_dynamic_workspace_symbols, opts)
map('n', '<leader>fb', builtin.buffers, opts)
map("n", "<leader>ts", "<cmd>Telescope<cr>", opts)
map("n", "<leader>df", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", opts)

require('modes').setup({
    colors = {
        copy = '#FFEE55',
        delete = '#DC669B',
        insert = '#55AAEE',
        visual = '#DD5522',
    },
})

-- indent_blankline config
vim.opt.list = true
vim.opt.listchars:append "eol:↴"
require("ibl").setup {}

vim.g.fuzzy_motion_matchers = 'kensaku'
vim.api.nvim_set_keymap(
    "n",
    "ff",
    ":FuzzyMotion<CR>",
    { noremap = true }
)

require('neogit').setup {
    integrations = {
        diffview = true
        -- {
        -- 'TimUntersberger/neogit',
        -- requires = {
        --   'nvim-lua/plenary.nvim',
        --   'sindrets/diffview.nvim'
        -- }
        -- }
    },
}
vim.keymap.set('n', '<leader>gg', ":Neogit<CR>", {})
vim.keymap.set('n', '<leader>gd', ":DiffviewOpen<CR>", {})
vim.keymap.set('n', '<leader>gD', ":DiffviewOpen staging<CR>", {})
vim.keymap.set('n', '<leader>gl', ":Neogit log<CR>", {})
vim.keymap.set('n', '<leader>gc', ":Neogit commit -v<CR>", {})

-- yamlやmarkdown,gitcommitのときにもcopilotを有効にする
vim.g.copilot_filetypes = { markdown = true, gitcommit = true, yaml = true }

function copy_relative_file_path_to_clipboard()
    local file_path = vim.fn.expand("%:~:.")
    if vim.fn.has('clipboard') == 1 then
        vim.fn.setreg('+', file_path)
        print("Copied relative file path to clipboard: " .. file_path)
    else
        print("Clipboard support is not available")
    end
end

-- キーバインドの設定 (例: <Leader>c で呼び出す)
vim.api.nvim_set_keymap('n', '<Leader>n', [[<Cmd>lua copy_relative_file_path_to_clipboard()<CR>]],
    { noremap = true, silent = true })
