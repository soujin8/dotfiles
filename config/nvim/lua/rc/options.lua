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
  vim.opt.clipboard:append { 'unnamedplus' }
end
vim.g.signcolumn = true

-- 補完表示時のEnterで改行をしない
vim.api.nvim_set_keymap("i", "<CR>", "pumvisible() ? '<C-y>' : '<CR>'", { expr = true, noremap = true })

-- why not working?
-- vim.g.loaded_node_provider = '~/.asdf/installs/nodejs/16.14.2/.npm/lib/node_modules/neovim/bin/cli.js'
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
