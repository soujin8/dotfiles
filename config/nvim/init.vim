" 遅延化
let g:did_install_default_menus = 1
let g:did_install_syntax_menu   = 1
let g:did_indent_on             = 1
let g:did_load_filetypes        = 1
let g:did_load_ftplugin         = 1
let g:loaded_2html_plugin       = 1
let g:loaded_gzip               = 1
let g:loaded_man                = 1
let g:loaded_matchit            = 1
let g:loaded_matchparen         = 1
let g:loaded_netrwPlugin        = 1
let g:loaded_remote_plugins     = 1
let g:loaded_shada_plugin       = 1
let g:loaded_spellfile_plugin   = 1
let g:loaded_tarPlugin          = 1
let g:loaded_tutor_mode_plugin  = 1
let g:loaded_zipPlugin          = 1
let g:skip_loading_mswin        = 1

" Option
" BSで行頭削除できる
set backspace=indent,eol,start
" 行数表示
set number
" 相対行数を表示
set relativenumber
" 改行時に前の行のインデントを継続
set autoindent
" tab size
set tabstop=2
" 自動インデントでずれる幅
set shiftwidth=2
"タブ入力を複数の空白入力に置き換える
set expandtab
" clipboard連携 
if has('mac')
  set clipboard+=unnamed
endif
if has('unix')
  set clipboard+=unnamedplus
endif
" ファイル更新反映までの時間
set updatetime=100
" 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smartindent
" インクリメンタルな検索が可能になる
set incsearch
" 検索結果のハイライト
set hlsearch
" 常にステータスラインを表示する
set laststatus=2
" 補完表示時の挙動
set completeopt=menuone,noinsert
" 補完表示時のEnterで改行をしない
inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"
" jj=esc
imap jj <Esc>
" プラグインとインデントを有効化
filetype plugin indent on
" filetype on
" 検索パターンにおいて大文字と小文字を区別しない
set ignorecase
" スワップファイルを作らない
set noswapfile
" バックアップファイル作らない
set nobackup
" undoファイル作らない
set noundofile
" 新しいウィンドウを→に開く
set splitright
" True Colorを使用する
set termguicolors
" buffer切替時に編集中ファイルを保存しなくてもOKにする
set hidden
" fugitive.vime Diffを立て分割にする
set diffopt+=vertical
" vimで使用するフォント
set guifont=HackGenNerd\ Console\ 14
set encoding=UTF-8
" mode表示しない
set noshowmode
" マウス無効
set mouse=
" コマンドのメッセージ表示欄を2行にする
set cmdheight=2

" NOTE: If barbar's option dict isn't created yet, create it
let bufferline = get(g:, 'bufferline', {})
" Enable/disable close button
let bufferline.closable = v:false

" フォルダアイコンを表示
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ""
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

" Node.js の参照先
let g:node_host_prog = '~/.asdf/installs/nodejs/16.14.2/.npm/lib/node_modules/neovim/bin/cli.js'

" dein Scripts-----------------------------
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
if &compatible
  set nocompatible
endif
" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('Shougo/deoplete.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif

  let g:rc_dir = expand('~/.config/nvim')
  let s:toml = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'
  " toml 読み込んでキャッシュする
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
	call map(dein#check_clean(), { _, val -> delete(val, 'rf') })
	call dein#recache_runtimepath()
endif
" 未インストールのものがあればインストールする
if dein#check_install()
  call dein#install()
endif
" plugin remove check {{{
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif
" }}}
"End dein Scripts-------------------------

" lightline.vim
" WORKDIRからの相対パスを表示する
function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'filename': 'LightlineFilename',
      \ },
      \ }


" Color scheme
" colorscheme iceberg
colorscheme oxocarbon-lua

" vim-markdown
" 折りたたみしない
let g:vim_markdown_folding_disabled = 1

" tab config of golang
autocmd FileType go setlocal noexpandtab
autocmd FileType go setlocal tabstop=4
autocmd FileType go setlocal shiftwidth=4
" tab config of Ruby
autocmd FileType rb setlocal noexpandtab
autocmd FileType rb setlocal tabstop=2

nnoremap Y y$

" Leader を Space に設定
let mapleader = "\<Space>"
" init.vimを開く
nnoremap <Space>. :<C-u>tabedit ~/.config/nvim/init.vim<CR>

" barbar.nvim
nnoremap <silent> <C-j> :BufferPrevious<CR>
nnoremap <silent> <C-k> :BufferNext<CR>
nnoremap <silent> <C-c> :BufferClose<CR>

" vim-fugitive
nmap <Leader>g [git]
nnoremap <silent> [git]a :Git add %:p<CR><CR>
nnoremap <silent> [git]c :Git commit<CR><CR>
nnoremap <silent> [git]s :Git<CR>
nnoremap <silent> [git]p :Git push<CR>
nnoremap <silent> [git]d :Gdiff<CR>
" nnoremap <silent> [git]l :Gclog<CR>
" nnoremap <silent> [git]b :Git blame<CR>

" fern
nmap <Leader>d [fern]
nnoremap <silent> [fern]f :Fern . -drawer<CR>
nnoremap <silent>sf :Fern .<CR>
let g:fern#default_hidden=1
let g:fern#renderer = "nerdfont"

function! s:fern_settings() abort
  nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
  nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
  nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
  nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)
endfunction

augroup fern-settings
  autocmd!
  autocmd FileType fern call s:fern_settings()
augroup END

" iamcco/markdown-preview.nvim'
nnoremap <Leader>md :MarkdownPreview<CR>

" vim-rspec
" map <Leader>t :call RunCurrentSpecFile()<CR>
" map <Leader>s :call RunNearestSpec()<CR>
" map <Leader>l :call RunLastSpec()<CR>
" map <Leader>a :call RunAllSpecs()<CR>

" nvim-treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  ignore_install = { "php", "phpdoc", "vim" },
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
  },
  context_commentstring = {
    enable = true
  }
}
EOF

" telescope
" nmap <leader>f [telescope]
" xmap <leader>f [telescope]

" nnoremap <silent> [telescope]f :Telescope find_files<CR>
" nnoremap <silent> [telescope]p :Telescope find_files hidden=true<CR>
" nnoremap <silent> [telescope]gr <cmd>Telescope grep_string<cr>
" nnoremap <silent> [telescope]gs <cmd>Telescope git_status<cr>
" nnoremap <silent> [telescope]gp <cmd>Telescope live_grep<cr>
" nnoremap <silent> [telescope]b <cmd>Telescope buffers<cr>
" nnoremap <silent> [telescope]o <cmd>Telescope oldfiles<cr>
" nnoremap <silent> [telescope]g <cmd>Telescope git_branches<cr>
" nnoremap <silent> [telescope]h <cmd>Telescope help_tags<cr>

lua <<EOF
-- require('telescope').setup{
--   extensions = {
--     fzf = {
--       fuzzy = true,                    -- false will only do exact matching
--       override_generic_sorter = false, -- override the generic sorter
--       override_file_sorter = true,     -- override the file sorter
--       case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
--                                        -- the default case_mode is "smart_case"
--     }
--   }
-- }
-- require('telescope').load_extension('fzf')
EOF

" fzf-preview.nvim
nmap <leader>f [fzf-p]
xmap <leader>f [fzf-p]

" find file
nnoremap <silent> [fzf-p]f     :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
nnoremap <silent> [fzf-p]gs    :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> [fzf-p]ga    :<C-u>CocCommand fzf-preview.GitActions<CR>
" nnoremap <silent> [fzf-p]b     :<C-u>CocCommand fzf-preview.Buffers<CR>
" nnoremap <silent> [fzf-p]<C-o> :<C-u>CocCommand fzf-preview.Jumps<CR>
" nnoremap <silent> [fzf-p]g;    :<C-u>CocCommand fzf-preview.Changes<CR>
" nnoremap <silent> [fzf-p]/     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
" nnoremap <silent> [fzf-p]*     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap          [fzf-p]gr    :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
xnoremap          [fzf-p]gr    "sy:CocCommand   fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
" nnoremap <silent> [fzf-p]t     :<C-u>CocCommand fzf-preview.BufferTags<CR>
" nnoremap <silent> [fzf-p]q     :<C-u>CocCommand fzf-preview.QuickFix<CR>
" nnoremap <silent> [fzf-p]l     :<C-u>CocCommand fzf-preview.LocationList<CR>

let g:fzf_preview_filelist_command = 'rg --files --hidden --follow --no-messages -g \!"* *"' " Installed ripgrep
let g:fzf_preview_command = 'bat --color=always --plain {-1}' " Installed bat
let g:fzf_preview_use_dev_icons = 1
let g:fzf_preview_dev_icons_limit = 5000

autocmd ColorScheme iceberg highlight CocFloating             ctermfg=NONE ctermbg=238                       guifg=NONE    guibg=#2C3538
autocmd ColorScheme iceberg highlight CocHoverFloating        ctermfg=NONE ctermbg=238                       guifg=NONE    guibg=#2A2D2F
autocmd ColorScheme iceberg highlight CocSuggestFloating      ctermfg=NONE ctermbg=238                       guifg=NONE    guibg=#2A2D2F
autocmd ColorScheme iceberg highlight CocSignatureFloating    ctermfg=NONE ctermbg=238                       guifg=NONE    guibg=#2A2D2F
autocmd ColorScheme iceberg highlight CocDiagnosticFloating   ctermfg=NONE ctermbg=238                       guifg=NONE    guibg=#2A2D2F

" vim-quickrun
nnoremap <silent><leader>r :QuickRun<CR>
let g:quickrun_config = {
\   "_" : {
\       "outputter" : "multi:buffer:quickfix",
\       "outputter/buffer/split" : ":botright 8px",
\       "runner" : "vimproc",
\       "runner/vimproc/updatetime" : 40,
\       "hook/close_quickfix/enable_hook_loaded" : 1,
\       "hook/close_quickfix/enable_success" : 1,
\       "hook/close_buffer/enable_failure" : 1,
\       "hook/close_buffer/enable_empty_data" : 1,
\       "hook/inu/enable" : 1,
\       "hook/inu/wait" : 20,
\   },
\}

" symbols-outlines
lua <<EOF
require('symbols-outline').setup()
EOF

" toggleterm.nvim
" refer https://zenn.dev/koga1020/articles/524e4c8c80db24
lua <<EOF
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

vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
EOF

" import divided file
set runtimepath+=./
runtime! *.rc.vim

