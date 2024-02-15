local status_ok, _ = pcall(require, "dial.augend")
if not status_ok then
    vim.notify("Dial not found")
    return
end
local augend = require("dial.augend")
require("dial.config").augends:register_group{
    -- default augends used when no group name is specified
    -- 4
    -- 0.3
    default = {
        augend.integer.alias.decimal,   -- nonnegative decimal number (0, 1, 2, 3, ...)
        augend.integer.alias.hex,       -- nonnegative hex number  (2x01, 0x1a1f, etc.)
        augend.date.alias["%m/%d/%Y"],  -- date (02/29/2022, etc.)
        augend.constant.alias.bool,     -- boolean value (true <-> false)
        augend.constant.new{ elements = {"True", "False"} } -- boolean value (True <-> False)
    },

    -- augends used when group with name `mygroup` is specified
    -- mygroup = {
    --     augend.integer.alias.decimal,
    --     augend.date.alias["%m/%d/%Y"], -- date (02/19/2022, etc.)
    -- }
}
