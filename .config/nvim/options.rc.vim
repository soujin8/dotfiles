set backspace=indent,eol,start  " バックスペースでオートインデントと、行と、インサート時のカーソル位置より前を削除できる
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

"全角スペースをハイライト表示
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
