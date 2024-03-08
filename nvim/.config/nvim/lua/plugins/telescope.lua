return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        lazy = false,
        opts = function()
            local actions = require("telescope.actions")
            return {
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    path_display = { "smart" },
                    mappings = {
                        i = {
                            ["<C-esc>"] = actions.close,
                            ["<C-n>"] = actions.cycle_history_next,
                            ["<C-p>"] = actions.cycle_history_prev,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-S-j>"] = function(b) require("telescope.actions.set").shift_selection(b, 10) end,
                            ["<C-S-K>"] = function(b) require("telescope.actions.set").shift_selection(b, -10) end,
                            ["<C-A-j>"] = function(b) require("telescope.actions.set").add_selection(b, 10) end,
                            ["<C-A-K>"] = function(b) require("telescope.actions.set").add_selection(b, -10) end,
                        },
                        n = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        }
                    },
                },
                pickers = {
                    find_files = {
                        theme = "dropdown",
                        previewer = false,
                    },
                    buffers = {
                        theme = "dropdown",
                        previewer = false,
                    },
                },
                extensions = {
                    harpoon = {
                        theme = "dropdown",
                        initial_mode = "insert",
                    }
                },
            }
        end,
        keys = {
            { "<leader>oo", "<cmd>Telescope find_files<cr>",           desc = "Find files" },
            { "<leader>og", "<cmd>Telescope live_grep<cr>",            desc = "Grep" },
            { "<leader>os", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
            { "<leader>op", "<cmd>Telescope project project<cr>",      desc = "Projects" },
            { "<leader>oi", "<cmd>Telescope buffers<cr>",              desc = "Buffers" },
        }
    },
    {
        "ThePrimeagen/harpoon",
        dependencies = "nvim-telescope/telescope.nvim",
        config = function()
            require("telescope").load_extension("harpoon")
        end,
        keys = function()
            local telescope_harpoon = require("telescope").extensions.harpoon.marks
            return {
                {
                    "<leader>h",
                    function()
                        telescope_harpoon(require("telescope.themes").get_dropdown {
                            previewer = false, initial_mode = "normal", prompt_title = "Harpoon"
                        })
                    end,
                    desc = "Harpoon marks"
                },
                { "mm",    require("harpoon.mark").add_file,                  desc = "Add file to harpoon" },
                { "<A-1>", function() require("harpoon.ui").nav_file(1) end, desc = "Open harpoon 1" },
                { "<A-2>", function() require("harpoon.ui").nav_file(2) end, desc = "Open harpoon 2" },
                { "<A-3>", function() require("harpoon.ui").nav_file(3) end, desc = "Open harpoon 3" },
                { "<A-4>", function() require("harpoon.ui").nav_file(4) end, desc = "Open harpoon 4" },
            }
        end
    },
}
