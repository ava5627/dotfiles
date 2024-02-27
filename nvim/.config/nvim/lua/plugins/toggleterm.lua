return {
    "akinsho/toggleterm.nvim",
    opts = {
        size = 20,
        open_mapping = [[<c-esc>]],
        direction = "float",
        float_opts = {
            border = "curved",
            winblend = 0,
        },
        shade_terminals = false,
    },
    config = function(_, opts)
        require("toggleterm").setup(opts)
        vim.api.nvim_create_autocmd("TermOpen", {
            pattern = "term://*",
            callback = function()
                local k_opts = { silent = true, noremap = true, buffer = true }
                vim.keymap.set("n", "<C-c>", "a<C-c>", k_opts)
            end,
        })
    end,
    lazy = false,
    keys = function()
        local python = require("toggleterm.terminal").Terminal:new({ cmd = "ipython3", hidden = true, direction = "float" })
        return {
            { "<C-t>p", function() python:toggle() end, desc = "Toggle ipython terminal", mode = { "n", "t" } },
            { "<esc>",  [[<C-\><C-n>]],                 desc = "Close terminal",          mode = "t" },
            { "<C-h>",  [[<C-\><C-n><C-W>h]],           desc = "Move left",               mode = "t" },
            { "<C-j>",  [[<C-\><C-n><C-W>j]],           desc = "Move down",               mode = "t" },
            { "<C-k>",  [[<C-\><C-n><C-W>k]],           desc = "Move up",                 mode = "t" },
            { "<C-l>",  [[<C-\><C-n><C-W>l]],           desc = "Move right",              mode = "t" },
            "<C-esc>"
        }
    end
}
