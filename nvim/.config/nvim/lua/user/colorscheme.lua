local set_hl = vim.api.nvim_set_hl
local function get_bg(name)
    return vim.api.nvim_get_hl_by_name(name, {}).background
end

local function get_fg(name)
    return vim.api.nvim_get_hl_by_name(name, {}).foreground
end


-- local color = "gruvbox"
-- local color = "sonokai"
-- local color = "darkplus"
local color = "tokyonight"

if color == "sonokai" then
    vim.g.sonokai_enable_italic = 1
    vim.g.sonokai_current_word = 'bold'
elseif color == "tokyonight" then
    require("user.tokyo")
end
local status, _ = pcall(vim.cmd, "colorscheme " .. color)
if not status then
    vim.notify("colorcheme " .. color .. " not found")
    return
  -- else
  --   vim.cmd [[hi Normal guibg=NONE ctermbg=NONE]]
end

-- vim.api.nvim_set_hl(0, "NormalNC", {bg = "#1E1E1E"})

if color == "sonokai" then
    set_hl(0, "NvimTreeGitDirty", {fg = get_fg("NvimTreeFolderIcon")})
    local normal_bg = get_bg('Normal')
    set_hl(0, "EndOfBuffer", {bg=normal_bg, fg=normal_bg})
    vim.cmd[[
        highlight! link TSParameter OrangeItalic
        highlight! link TSParameterReference OrangeItalic
        highlight! link TSFuncBuiltin Blue
    ]]
end

