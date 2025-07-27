local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function filename()
  local name = vim.fn.expand("%:t:r")
  return name
end

return {
  s("rfc", {
    t("interface Props {"),
    t({ "", "  " }), i(1),
    t({ "", "}", "", "" }),
    t("export const "), f(filename, {}), t(" = (props: Props) => {"),
    t({ "", "  return (" }),
    t({ "", "    " }), i(2),
    t({ "", "  )", "" }),
    t("}")
  }),
}