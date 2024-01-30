local status_ok, neoscroll = pcall(require, "neoscroll")
if not status_ok then
    vim.api.nvim_err_writeln("neoscroll not found")
    return
end

neoscroll.setup({
    -- All these keys will be mapped to their corresponding default scrolling animation
    mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
                '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
    hide_cursor = false,         -- Hide cursor while scrolling
    stop_eof = false,            -- Stop at <EOF> when scrolling downwards
    use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = 'sine',    -- Default easing function
    pre_hook = nil,              -- Function to run before the scrolling animation starts
    post_hook = nil,             -- Function to run after the scrolling animation ends
    performance_mode = false,    -- Disable "Performance Mode" on all buffers.
})
local t = {}
-- Syntax: t[keys] = {function, {function arguments}}
t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '200'}}
t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '200'}}
t['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '350', nil}}
t['<C-f>'] = {'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '350', nil}}
t['<C-y>'] = {'scroll', {'-0.10', 'false', '100'}}
t['<C-e>'] = {'scroll', { '0.10', 'false', '100'}}
t['<A-k>'] = {'scroll', {'-10', 'true', '50'}}
t['<A-j>'] = {'scroll', { '10', 'true', '50'}}
t['zt']    = {'zt', {'200'}}
t['zz']    = {'zz', {'200'}}
t['zb']    = {'zb', {'200'}}

require('neoscroll.config').set_mappings(t)
