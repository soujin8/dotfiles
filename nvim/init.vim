"-------------------------------------------------------------------------------
" Option
"-------------------------------------------------------------------------------
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
  set clipboard=unnamedplus
endif
" ファイル更新反映までの時間
set updatetime=100
" 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smartindent
" インクリメンタルな検索が可能になる
" set incsearch
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

"-------------------------------------------------------------------------------
" Dein
"-------------------------------------------------------------------------------

"let s:dein_dir = expand('~/.cache/dein')
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
"if dein#load_state(s:dein_dir)
"  call dein#begin(s:dein_dir)
"
"  let g:rc_dir = expand('~/dotfiles/nvim')
"  let s:toml = g:rc_dir . '/dein.toml'
"  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'
"  call dein#load_toml(s:toml,      {'lazy': 0})
"  call dein#load_toml(s:lazy_toml, {'lazy': 1})
"
"  call dein#end()
"  call dein#save_state()
"endif
"if dein#check_install()
"  call dein#install()
"endif

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

  let g:rc_dir = expand('~/dotfiles/nvim')
  let s:toml = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif
if dein#check_install()
  call dein#install()
endif

"-------------------------------------------------------------------------------
" Color scheme
"-------------------------------------------------------------------------------
" set background=dark
" let g:hybrid_custom_term_colors = 1
" let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette.
" colorscheme hybrid
" colorscheme hybrid_material

"-------------------------------------------------------------------------------
" Other plugins
"-------------------------------------------------------------------------------

" vim-go
let g:go_disable_autoinstall = 1
let g:go_metalinter_autosave = 1
let g:go_fmt_command = "goimports"

" vim-jsx-pretty
let g:vim_jsx_pretty_colorful_config = 1

" vim-markdown
" 折りたたみしない
let g:vim_markdown_folding_disabled = 1

" Status line
if !exists('*fugitive#statusline')
  set statusline=%F\ %m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}[L%l/%L,C%03v]
  set statusline+=%=
  set statusline+=%{fugitive#statusline()}
endif

" vim-delve
" ;dでその行にブレークポイントを設定
autocmd FileType go nmap <silent> ;d :DlvToggleBreakpoint<CR>

"-------------------------------------------------------------------------------
" Tab Config each language
"-------------------------------------------------------------------------------
" tab config of golang
autocmd FileType go setlocal noexpandtab
autocmd FileType go setlocal tabstop=4
autocmd FileType go setlocal shiftwidth=4
" tab config of Ruby
autocmd FileType rb setlocal noexpandtab
autocmd FileType rb setlocal tabstop=2

"-------------------------------------------------------------------------------
" fzf
"-------------------------------------------------------------------------------

" let $FZF_DEFAULT_OPTS="--layout=reverse"
" let $FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git/**'"
" let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'border': 'sharp' } }

let mapleader = "\<Space>"
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>g :GFiles<CR>
nnoremap <silent> <leader>G :GFiles?<CR>
nnoremap <silent> <leader>b :Buffers<CR>
" nnoremap <silent> <leader>h :History<CR>
nnoremap <silent> <leader>r :Rg<CR>

"-------------------------------------------------------------------------------
" import divided file
"-------------------------------------------------------------------------------
runtime ~/dotfiles/nvim/*.vim
" runtime ~/dotfiles/nvim/.vimrc.lightline

" 構文ハイライトを有効
"syntax on
