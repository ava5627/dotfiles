local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    vim.notify("Telescope Not Found")
    return
end

local actions = require("telescope.actions")

telescope.setup {
    defaults = {

        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },
        mappings = {
            i = {
                ["<C-n>"] = actions.cycle_history_next,
                ["<C-p>"] = actions.cycle_history_prev,

                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,

                ["<C-c>"] = actions.close,

                ["<Down>"] = actions.move_selection_next,
                ["<Up>"] = actions.move_selection_previous,

                ["<CR>"] = actions.select_default,
                ["<S-CR>"] = actions.select_horizontal,
                ["<C-CR>"] = actions.select_vertical,
                ["<C-t>"] = actions.select_tab,

                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,

                ["<PageUp>"] = actions.results_scrolling_up,
                ["<PageDown>"] = actions.results_scrolling_down,

                ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                ["<C-l>"] = actions.complete_tag,
                ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
            },

            n = {
                ["<esc>"] = actions.close,
                ["dd"] = actions.delete_buffer,
                ["<CR>"] = actions.select_default,
                ["<S-CR>"] = actions.select_horizontal,
                ["<C-CR>"] = actions.select_vertical,
                ["<C-t>"] = actions.select_tab,

                ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

                ["j"] = actions.move_selection_next,
                ["k"] = actions.move_selection_previous,
                ["H"] = actions.move_to_top,
                ["M"] = actions.move_to_middle,
                ["L"] = actions.move_to_bottom,

                ["<Down>"] = actions.move_selection_next,
                ["<Up>"] = actions.move_selection_previous,
                ["gg"] = actions.move_to_top,
                ["G"] = actions.move_to_bottom,

                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,

                ["<PageUp>"] = actions.results_scrolling_up,
                ["<PageDown>"] = actions.results_scrolling_down,

                ["?"] = actions.which_key,
            },
        },
    },
    pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --     picker_config_key = value,
        --     ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
        live_grep = {
        },
        grep_string = {
        },
        find_files = {
            theme = "dropdown",
            previewer = false,
        },
        buffers = {
            theme = "dropdown",
            previewer = false,
        },
        colorscheme = {
            -- enable_preview = true,
        },
        lsp_references = {
            -- initial_mode = "normal",
        },
        lsp_definitions = {
            -- initial_mode = "normal",
        },
        lsp_declarations = {
            -- initial_mode = "normal",
        },
        lsp_implementations = {
            -- initial_mode = "normal",
        },
    },
    extensions = {
        -- Your extension configuration goes here:
        -- extension_name = {
        --     extension_config_key = value,
        -- }
        project = {
            hidden_files = false,
        },
        harpoon = {
            theme = "dropdown",
        }

        -- please take a look at the readme of the extension you want to configure
    },
}

telescope.load_extension('project')
telescope.load_extension('harpoon')
