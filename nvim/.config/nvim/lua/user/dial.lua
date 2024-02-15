local dial_ok, augend = pcall(require, "dial.augend")
if not dial_ok then
    vim.notify("Dial not found")
    return
end
require("dial.config").augends:register_group{
    default = {
        augend.integer.alias.decimal_int,   -- nonnegative decimal number (0, 1, 2, 3, ...)
        augend.integer.alias.hex,       -- nonnegative hex number  (2x01, 0x1a1f, etc.)
        augend.constant.alias.bool,     -- boolean value (true <-> false)
        augend.constant.new{ elements = {"True", "False"} }, -- boolean value (True <-> False)
        augend.constant.new{ elements = {"Yes", "No"} }, -- boolean value (Yes <-> No)
        augend.constant.new{ elements = {"yes", "no"} }, -- boolean value (yes <-> no)
        augend.date.alias["%m/%d/%Y"],  -- date (03/01/2024, etc.)
    },
}
