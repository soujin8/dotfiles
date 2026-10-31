-- 呼び出したクライアントがタブを表示するまで、選択を再試行する。
local target, err = rex.session.describe_block{ block_id = rex.args.block_id }
if not target then error(err, 0) end
if not target.block.window_id then error("Copy Mode is no longer in a tab", 0) end

-- ctx.client_idがホーム側のIDでも、端末側のGUIクライアントへ送る。
local function connected_app(id)
    if not id then return nil end
    local result = rex.call("client.inspect", { client_id = id })
    local client = result and result.client
    if client and client.info and client.info.kind == "app"
        and (not client.connection_state or client.connection_state == "connected") then
        return client.client_id
    end
end

local client_id = connected_app(target.block.owner) or connected_app(rex.args.client_id)
if not client_id then
    local result, list_err = rex.call("client.list", {})
    if not result then error(list_err, 0) end
    for _, client in ipairs(result.clients) do
        if client.info and client.info.kind == "app"
            and (not client.connection_state or client.connection_state == "connected") then
            if client_id then error("Cannot choose between multiple Rex app clients", 0) end
            client_id = client.client_id
        end
    end
end
if not client_id then error("No connected Rex app client", 0) end

for attempt = 1, 31 do
    local size, size_err = rex.block.call("com.superlogical.terminal", "size", {})
    if not size then error(size_err, 0) end
    for _, request in ipairs(size.desired) do
        if request.client_id == client_id then
            return
        end
    end

    if attempt == 31 then break end
    local performed, perform_err = rex.call("client.perform", {
        client_id = client_id,
        action = "session.select",
        session_id = rex.args.session_id,
        block_id = rex.args.block_id,
        args = {
            session_id = rex.args.session_id,
            window_id = target.block.window_id,
        },
    })
    if not performed then error(perform_err, 0) end
    rex.sleep(0.1)
end

error("Copy Mode tab was created but the client did not display it", 0)
