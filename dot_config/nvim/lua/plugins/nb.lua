-- snacks.nvimでノートをタイトル一覧から検索して開く
local function pick_notes()
  local nb = require("rc.nb")
  local Snacks = require("snacks")
  local items = nb.list_items()

  if not items or #items == 0 then
    vim.notify("No notes found", vim.log.levels.WARN)
    return
  end

  Snacks.picker({
    title = "nb Notes",
    items = items,
    format = function(item)
      return { { item.text } }
    end,
    preview = function(ctx)
      local item = ctx.item
      if not item.file then
        item.file = nb.get_note_path(item.note_id)
      end
      return Snacks.picker.preview.file(ctx)
    end,
    confirm = function(picker, item)
      picker:close()
      if item then
        vim.cmd.edit(nb.get_note_path(item.note_id))
      end
    end,
    actions = {
     delete_note = function(picker)
       local item = picker:current()
       if item and vim.fn.confirm("Delete: " .. item.text .. "?", "&Yes\n&No") == 1 then
         picker:close()
         if nb.delete_note(item.note_id) then
           vim.notify("Deleted", vim.log.levels.INFO)
           pick_notes()
         end
       end
     end
   },
   win = {
     input = {
       keys = {
         ["<C-d>"] = { "delete_note", mode = { "n", "i" }, desc = "Delete note" },
       },
     },
   },
  })
end

-- snacks.nvimでノートの内容をgrep検索
local function grep_notes()
  local nb = require("rc.nb")
  local Snacks = require("snacks")
  Snacks.picker.grep({
    dirs = { nb.get_nb_dir() },
  })
end

-- ノートを追加して開く
local function add_note()
  local nb = require("rc.nb")
  vim.ui.input({ prompt = "Note title (empty for timestamp): " }, function(title)
    local note_id = nb.add_note(title)
    if note_id then
      local path = nb.get_note_path(note_id)
      if path and path ~= "" then
        vim.cmd.edit(path)
      end
    else
      vim.notify("Failed to add note", vim.log.levels.ERROR)
    end
  end)
end

return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>na", add_note, desc = "nb add" },
    { "<leader>np", pick_notes, desc = "nb picker" },
    { "<leader>ng", grep_notes, desc = "nb grep" },
  },
}
