set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" !! write plugins here !!
" プラグイン管理
Plugin 'VundleVim/Vundle.vim'
" git
Plugin 'airblade/vim-gitgutter'
" ファイルツリー
Plugin 'preservim/nerdtree'
" end挿入
Plugin 'tpope/vim-endwise'
" railsコマンド
Plugin 'tpope/vim-rails'
" Slim
Plugin 'slim-template/vim-slim'
" ale関連
Plugin 'neoclide/coc.nvim'
Plugin 'dense-analysis/ale'
" カラースキーマ
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'jacoborus/tender.vim'
" git
Plugin 'tpope/vim-fugitive'
" Rubyリファレンス
Plugin 'thinca/vim-ref'
Plugin 'ruby-formatter/rufo-vim'
" あいまい検索fzf
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
" JavaScript syntax highlighting
Plugin 'neovim/node-host', { 'do': 'npm install' }
Plugin 'billyvg/tigris.nvim', { 'do': './install.sh' }
" golang
Plugin 'fatih/vim-go'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" vim option {{{
" 折りたたみ
set foldmethod=marker
" バックスペースでオートインデントと、行と、インサート時のカーソル位置より前を削除できる
set backspace=indent,eol,start
set number  "行番号を表示
set autoindent		"改行で自動インデント
set tabstop=2		"タブの文字数
set shiftwidth=2	"自動インデント時の空白の数
set expandtab		"タブを空白に変換
set clipboard+=unnamed	"yankした文字列をクリップボードにもコピー
set updatetime=100  "Git更新が反映されるまでの時間
set statusline=%{FugitiveStatusline()} " ステータスラインにbranch表示
set cursorline "カーソルのある行を色付け
"タブ、空白、改行の可視化
set list
set list listchars=trail:»,tab:»-
" 検索単語ハイライト時の背景色
set hlsearch
hi Search gui=NONE
hi Search guifg=LightYellow
hi Search guibg=Blue
" ESC to jj 
"inoremap <silent> jj <ESC>
imap jj <Esc>

" tab config of golang
autocmd FileType go setlocal noexpandtab
autocmd FileType go setlocal tabstop=4
autocmd FileType go setlocal shiftwidth=4
" tab config of Ruby
autocmd FileType rb setlocal noexpandtab
autocmd FileType rb setlocal tabstop=2
"}}}
"NERDTreeの設定{{{
noremap <silent><C-e> :NERDTreeToggle<CR> " NERDTreeをコマンドで開く
let NERDTreeShowBookmarks = 1
autocmd VimEnter * NERDTree
"}}}
" => vim-airlineの設定 --------------------------------------------------------------------------------- {{{1
let g:airline_theme = 'tender' " tenderテーマを使用
let g:airline#extensions#tabline#enabled = 1  " airlineでタブを表示させる
" タブ移動
nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab
" タブに番号を表示する
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffer_idx_format = {
	\ '0': '0 ',
	\ '1': '1 ',
	\ '2': '2 ',
	\ '3': '3 ',
	\ '4': '4 ',
	\ '5': '5 ',
	\ '6': '6 ',
	\ '7': '7 ',
	\ '8': '8 ',
	\ '9': '9 '
	\}
" tenderの設定
if (has("termguicolors"))
set termguicolors
endif
syntax enable
colorscheme tender
" NERDTreeを同時に閉じる
autocmd bufenter * if (winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) | q | endif
"}}}
" => 全角スペースをハイライト表示 ---------------------------------- {{{
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction

if has('syntax')
  augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme       * call ZenkakuSpace()
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif
"}}}
" => aleのfixer設定 ---------------------------- {{{
let g:ale_fixers = {
\   'ruby': ['rubocop'],
\}
"}}}
" => coc.nvimによるLSPの設定 ------------------------ {{{
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
"}}}
" => JavaScript tigris設定-----------------------------{{{
let g:tigris#enabled = 1
let g:tigris#on_the_fly_enabled = 1
let g:tigris#delay = 300
" }}}
