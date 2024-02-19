return {
    "karb94/neoscroll.nvim",
    opts = {
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
            '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = false,  -- Hide cursor while scrolling
        stop_eof = false,     -- Stop at <EOF> when scrolling downwards
        easing_function = 'sine', -- Default easing function
    },
    config = function(_, opts)
        require('neoscroll').setup(opts)
        local t    = {}
        t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '200' } }
        t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '200' } }
        t['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '350', nil } }
        t['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '350', nil } }
        t['<C-y>'] = { 'scroll', { '-0.10', 'false', '100' } }
        t['<C-e>'] = { 'scroll', { '0.10', 'false', '100' } }
        t['<A-k>'] = { 'scroll', { '-10', 'true', '50' } }
        t['<A-j>'] = { 'scroll', { '10', 'true', '50' } }
        t['zt']    = { 'zt', { '200' } }
        t['zz']    = { 'zz', { '200' } }
        t['zb']    = { 'zb', { '200' } }
        require('neoscroll.config').set_mappings(t)
    end
}
