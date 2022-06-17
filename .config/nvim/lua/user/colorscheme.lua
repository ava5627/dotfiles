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

-- vim.api.nvim_set_hl(0, "NormalNC", {bg = "#1E1E1E"})
vim.api.nvim_set_hl(0, "NvimTreeGitDirty", {fg = "#FFFFFF"})
-- vim.api.nvim_set_hl(0, "EndOfBuffer", {bg = "NONE", fg="bg"})
