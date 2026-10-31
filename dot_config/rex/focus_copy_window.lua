-- 呼び出したクライアントがタブを表示するまで、選択を再試行する。
local target, err = rex.session.describe_block{ block_id = rex.args.block_id }
if not target then error(err, 0) end
if not target.block.window_id then error("Copy Mode is no longer in a tab", 0) end

for attempt = 1, 31 do
    local size, size_err = rex.block.call("com.superlogical.terminal", "size", {})
    if not size then error(size_err, 0) end
    for _, request in ipairs(size.desired) do
        if request.client_id == rex.args.client_id then
            return
        end
    end

    if attempt == 31 then break end
    rex.client.queue("session.select", {
        session_id = rex.args.session_id,
        window_id = target.block.window_id,
    })
    rex.sleep(0.1)
end

error("Copy Mode tab was created but the client did not display it", 0)
