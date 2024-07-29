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

-- why not working?
-- vim.g.loaded_node_provider = '~/.asdf/installs/nodejs/16.14.2/.npm/lib/node_modules/neovim/bin/cli.js'
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0


-- LSPサーバアタッチ時の処理
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ctx)
    local set = vim.keymap.set
    set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = true })
    set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = true })
    set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { buffer = true })
    set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { buffer = true })
    set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { buffer = true })
    set("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", { buffer = true })
    set("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", { buffer = true })
    set("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", { buffer = true })
    set("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { buffer = true })
    set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { buffer = true })
    set("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { buffer = true })
    set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { buffer = true })
    set("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", { buffer = true })
    set("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", { buffer = true })
    set("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", { buffer = true })
    set("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", { buffer = true })
    set("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", { buffer = true })
  end,
})

-- プラグインの設定
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
  function(server_name)
    require("lspconfig")[server_name].setup {}
  end,
}

-- lspのハンドラーに設定
-- capabilities = require("cmp_nvim_lsp").default_capabilities(),

-- lspの設定後に追加
-- vim.opt.completeopt = "menu,menuone,noselect"


local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  })
})
