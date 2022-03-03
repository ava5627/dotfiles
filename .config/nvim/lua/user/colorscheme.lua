-- local color = "gruvbox"
local color = "sonokai"
-- local color = "darkplus"


local status, _ = pcall(vim.cmd, "colorscheme " .. color)
if not status then
    vim.notify("colorcheme" .. color .. " not found")
    return
  -- else
  --   vim.cmd [[hi Normal guibg=NONE ctermbg=NONE]]
end

vim.cmd [[
    highlight NormalNC guibg=#1E1E1E
    highlight EndOfBuffer guibg=NONE
]]


