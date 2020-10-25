"-------------------------------------------------------------------------------
" Option
"-------------------------------------------------------------------------------
set backspace=indent,eol,start
set number
set autoindent
set tabstop=2
set shiftwidth=2
set expandtab
set clipboard+=unnamed
set updatetime=100
set smartindent
set incsearch
set list
set list listchars=trail:»,tab:»-
set hlsearch
hi Search gui=NONE
hi Search guifg=LightYellow
hi Search guibg=Blue
set laststatus=2
set completeopt=menuone,noinsert
" 補完表示時のEnterで改行をしない
inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"

syntax on
imap jj <Esc>

"-------------------------------------------------------------------------------
" Dein
"-------------------------------------------------------------------------------

let s:dein_dir = expand('~/.cache/dein')
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let g:rc_dir = expand('~/dotfiles/.nvim/settings/plugin/dein')
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

filetype plugin indent on

"-------------------------------------------------------------------------------
" Color scheme
"-------------------------------------------------------------------------------

" true color
if exists("&termguicolors") && exists("&winblend")
  let g:neosolarized_termtrans=1
  "runtime ~/dotfiles/.nvim/settings/colors/solarized_true.vim
  runtime ./.nvim/settings/colors/solarized_true.vim
  set termguicolors
  set winblend=0
  set wildoptions=pum
  set pumblend=5
endif

let g:solarized_termtrans=1
let g:solarized_termcolors=256
colorscheme solarized

"-------------------------------------------------------------------------------
" Other plugins
"-------------------------------------------------------------------------------

" vim-go
let g:go_disable_autoinstall = 1
let g:go_fmt_command = "goimports"

" Status line
if !exists('*fugitive#statusline')
  set statusline=%F\ %m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}[L%l/%L,C%03v]
  set statusline+=%=
  set statusline+=%{fugitive#statusline()}
endif

"-------------------------------------------------------------------------------
" Cursor line
"-------------------------------------------------------------------------------

set cursorline
autocmd InsertEnter * highlight CursorLine guibg=#0000ff guifg=fg
autocmd InsertLeave * highlight CursorLine guibg=#0050ff guifg=fg

" tab config of golang
autocmd FileType go setlocal noexpandtab
autocmd FileType go setlocal tabstop=4
autocmd FileType go setlocal shiftwidth=4
" tab config of Ruby
autocmd FileType rb setlocal noexpandtab
autocmd FileType rb setlocal tabstop=2

" ale fixer
let g:ale_fixers = {
\   'ruby': ['rubocop'],
\}

" coc.nvim
let g:coc_global_extensions = ['coc-solargraph']

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Javascript tigris
let g:tigris#enabled = 1
let g:tigris#on_the_fly_enabled = 1
let g:tigris#delay = 300

runtime! .nvim/*.vim
runtime! .nvim/settings/plugin/*.vim

source ~/dotfiles/.vimrc.lightline
