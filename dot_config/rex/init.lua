-- ~/.tmux.conf に合わせ、Ctrl+s をプレフィックスにする。
-- 変更後: rex config check && rex config reload

-- ペイン分割
rex.bind("ctrl+s>v", "pane.split", { direction = "right" })
rex.bind("ctrl+s>s", "pane.split", { direction = "down" })
rex.bind("ctrl+s>shift+\\", "pane.split", { direction = "right" }) -- |
rex.bind("ctrl+s>-", "pane.split", { direction = "down" })

-- ペイン移動: H / J / K / L
rex.bind("ctrl+s>shift+h", "pane.focus", { direction = "left" })
rex.bind("ctrl+s>shift+j", "pane.focus", { direction = "down" })
rex.bind("ctrl+s>shift+k", "pane.focus", { direction = "up" })
rex.bind("ctrl+s>shift+l", "pane.focus", { direction = "right" })

-- ペインサイズ変更
rex.bind("ctrl+s>up", "pane.resize", { direction = "up", amount = 5 })
rex.bind("ctrl+s>down", "pane.resize", { direction = "down", amount = 5 })
rex.bind("ctrl+s>left", "pane.resize", { direction = "left", amount = 5 })
rex.bind("ctrl+s>right", "pane.resize", { direction = "right", amount = 5 })

-- tmuxのwindowに相当するRexのタブ
rex.bind("ctrl+s>c", "client.tab.new")
rex.bind("ctrl+s>j", "client.tab.next")
rex.bind("ctrl+s>k", "client.tab.previous")
rex.bind("ctrl+s>n", "client.tab.next")
rex.bind("ctrl+s>p", "client.tab.previous")

-- セッション
rex.bind("ctrl+s>shift+c", "session.new")
rex.bind("ctrl+s>l", "session.next")
rex.bind("ctrl+s>h", "session.previous")
rex.bind("ctrl+s>e", "session.switch")
-- Rexにはtmuxのchoose-treeと同じ一覧がないため、セッション選択を開く。
rex.bind("ctrl+s>a", "session.switch")
rex.bind("ctrl+s>w", "session.switch")

-- tmuxの標準操作
rex.bind("ctrl+s>o", "pane.focus_next")
rex.bind("ctrl+s>z", "pane.zoom")
rex.bind("ctrl+s>x", "pane.close")
rex.bind("ctrl+s>r", "client.config.reload")

-- ネストしたtmuxなどへCtrl+sを送るには、Ctrl+sを2回押す。
rex.bind("ctrl+s>ctrl+s", "pane.send_key", { key = "ctrl+s" })

-- 元のペインを指定して履歴を取得し、専用タブで読む。
rex.action{
    name = "copy_mode",
    title = "Copy Mode (Neovim)",
    run = function(ctx)
        if not ctx.block_id then error("Focus a terminal first", 0) end
        local focus_script = (os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")) .. "/rex/focus_copy_window.lua"
        local window, err = rex.session.new_window{
            window_label = "Copy Mode",
            layout = rex.layout.block{
                flavor = "com.superlogical.terminal.shell",
                options = {
                    command = { "/bin/sh", "-c", [[
set -eu
capture=$(mktemp "${TMPDIR:-/tmp}/rex-copy.XXXXXX")
trap 'rm -f "$capture"' EXIT
trap 'exit 0' HUP INT TERM
"$REX_BIN_DIR/rex" capture --block "$1" --trim --unwrap > "$capture"
# 選択要求が失敗しても、閲覧用のタブは残す。
"$REX_BIN_DIR/rex" -C "$2" do "$3" \
    "session_id=$REX_SESSION" "block_id=$REX_BLOCK" "client_id=$2" >/dev/null || true
nvim --clean -n -R \
    --cmd 'set nomodeline clipboard=unnamedplus' \
    -c 'call delete(expand("%:p"))' \
    -c 'setlocal buftype=nofile bufhidden=wipe noswapfile nomodifiable' \
    -c 'nnoremap <silent> q :qa!<CR>' \
    -c 'xnoremap <silent> q <Esc>:qa!<CR>' \
    -c 'normal! G$' \
    "$capture"
"$REX_BIN_DIR/rex" focus "$1" >/dev/null
]], "rex-copy-mode", ctx.block_id, ctx.client_id, focus_script },
                },
            },
        }
        if not window then error(err, 0) end
        rex.client.queue("session.select", {
            session_id = ctx.session_id,
            window_id = window.window_id,
        })
        return window
    end,
}
rex.bind("ctrl+s>[", "copy_mode")

-- 接続先はGit管理外のローカル設定から読み込む。
local config_home = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
local hosts_path = config_home .. "/rex/hosts.lua"
local hosts_file = io.open(hosts_path, "r")
if hosts_file then
    hosts_file:close()
    dofile(hosts_path)
end
