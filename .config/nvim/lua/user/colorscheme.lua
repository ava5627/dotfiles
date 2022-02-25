local color = "gruvbox"


local status, _ = pcall(vim.cmd, "colorscheme " .. color)
if not status then
    vim.notify("colorcheme" .. color .. " not found")
    return
end

require'colorizer'.setup()
