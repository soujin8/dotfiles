-- vim.cmd("autocmd!")

vim.scriptencoding = "utf-8"
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- BSで行頭削除できる
vim.opt.backspace = "indent,eol,start"
-- 行数表示
vim.opt.number = true
-- 相対行表示
vim.opt.relativenumber = true
-- 改行時に前の行のインデントを継続
vim.opt.autoindent = true
-- tab size
vim.opt.tabstop = 2
-- 自動インデントでずれる幅
vim.opt.shiftwidth = 2
-- タブ入力を複数の空白入力に置き換える
vim.opt.expandtab = true
-- フォント
vim.opt.guifont = 'PlemolJP Console NF'
-- ファイル更新反映までの時間
vim.opt.updatetime = 500
-- 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
vim.opt.smartindent = true
-- インクリメンタルな検索を可能にする
vim.opt.incsearch = true
-- 検索結果のハイライト
vim.opt.hlsearch = true
-- 常にステータスラインを表示する
vim.opt.laststatus = 2
-- 補完表示時の挙動
vim.opt.completeopt = "menuone,noinsert"
-- プラグインとインデントを有効化
vim.cmd("filetype plugin indent on")
-- 検索パターンにおいて大文字と小文字を区別しない
vim.opt.ignorecase = true
-- スワップファイルを作らない
vim.opt.swapfile = false
-- バックアップファイル作らない
vim.opt.backup = false
-- undoファイル作らない
vim.opt.undofile = false
-- 新しいウィンドウを→に開く
vim.opt.splitright = true
-- True Colorを使用する
vim.opt.termguicolors = true
-- buffer切替時に編集中ファイルを保存しなくてもOKにする
vim.opt.hidden = true
-- fugitive.vim Diffを立て分割にする
vim.opt.diffopt = "vertical"
-- mode表示しない
vim.opt.showmode = false
-- マウス無効
vim.opt.mouse = ""
-- コマンドのメッセージ表示欄を2行にする
vim.opt.cmdheight = 2
-- クリップボード
if vim.fn.has('mac') == 1 then
  vim.opt.clipboard = "unnamed"
end
if vim.fn.has('unix') == 1 then
  vim.opt.clipboard = "unnamedplus"
end
vim.g.signcolumn = true

-- 補完表示時のEnterで改行をしない
vim.api.nvim_set_keymap("i", "<CR>", "pumvisible() ? '<C-y>' : '<CR>'", { expr = true, noremap = true })
-- jj=esc
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true })
-- spaceをleader keyに設定
vim.g.mapleader = " "

-- why not working?
-- vim.g.loaded_node_provider = '~/.asdf/installs/nodejs/16.14.2/.npm/lib/node_modules/neovim/bin/cli.js'
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

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
  {'neoclide/coc.nvim', branch = 'release'},
  -- log highlight
  'mtdl9/vim-log-highlighting',
  'tpope/vim-commentary',
  -- util markfown table mode
  'dhruvasagar/vim-table-mode',
  -- file icons
  'kyazdani42/nvim-web-devicons',
  -- manage tabline
  -- {'romgrk/barbar.nvim', requires = 'kyazdani42/nvim-web-devicons'},
  -- using packer.nvim
  {'akinsho/bufferline.nvim', tag = "v3.3.0", dependencies = {'kyazdani42/nvim-web-devicons'}},
  -- filer
  'lambdalisue/fern.vim',
  {'lambdalisue/fern-renderer-nerdfont.vim', dependencies = {'lambdalisue/fern.vim'}},
  {'lambdalisue/nerdfont.vim', dependencies = 'lambdalisue/fern.vim'},
  -- ecosystem to develop with deno
  'vim-denops/denops.vim',
  -- syntaxhilight
  {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
  -- treesitter plugin
  'windwp/nvim-ts-autotag',
  -- A Neovim plugin for setting the commentstring option based on the cursor location in the file. The location is checked via treesitter queries.
  'JoosepAlviste/nvim-ts-context-commentstring',
  {
	"windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  },
  -- color preview
  'norcalli/nvim-colorizer.lua',
  -- surroundings operator, textobject
  'machakann/vim-sandwich',
  -- to camelcase or snakecase etc...
  'nicwest/vim-camelsnek',
  'thinca/vim-quickrun',
  -- async quickrun
  {'Shougo/vimproc.vim', run = 'make'},
  -- quickrun plugin
  'osyo-manga/shabadou.vim',
  -- {'iamcco/markdown-preview.nvim', run = 'sh -c "cd app && yarn install"'},
  -- markfown preview
  { 'toppair/peek.nvim', run = 'deno task --quiet build:fast' },
  'akinsho/toggleterm.nvim',
  -- git plugin
  'lewis6991/gitsigns.nvim',
  -- common utilities
  'nvim-lua/plenary.nvim',
  {'sindrets/diffview.nvim', dependencies = 'nvim-lua/plenary.nvim'},
  'tpope/vim-rails',
  -- statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons', opt = true }
  },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    dependencies = { {'nvim-lua/plenary.nvim'} }
  },
  {'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
})
-- lazy.nvim config END

vim.cmd("colorscheme iceberg")

-- plugin config

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
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
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

require'nvim-treesitter.configs'.setup {
  -- ensure_installed = "all",
  -- ensure_installed = {"ruby","css","html","javascript","typescript","python","rust","go","sql","yaml","vue","tsx","terraform","scss","markdown","lua","vim","bash","json","toml"},
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

require('gitsigns').setup{
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
  on_attach = function(bufnr)
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
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hd', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}

require("bufferline").setup{}

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
vim.keymap.set("n", "<Leader>df", ":Fern . -drawer<CR>")
vim.g['fern#default_hidden'] = 1
vim.g['fern#renderer'] = 'nerdfont'
vim.g['fern#renderer#nerdfont#indent_markers'] = 1

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

-- peek.nvim. markdown preview
vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
vim.keymap.set("n", "<Leader>md", ":PeekOpen<CR>")

require('colorizer').setup()
require("diffview").setup({})

require('coc')

require('telescope').setup{
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
-- require('telescope').load_extension('fzf')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
