local status_ok, _ = pcall(require, "nvim-treesitter")
if not status_ok then
    vim.notify("Treesitter Not Found")
    return
end
require("nvim-treesitter.configs").setup {
    ensure_installed = "all",
    sync_install = false,
    ignore_install = { "" }, -- List of parsers to ignore installing
    autopairs = {
        enable = true,
    },
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = { "latex" }, -- list of language that will be disabled
        additional_vim_regex_highlighting = false,
        custom_captures = {
            -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
            --[[ ["foo.bar"] = "Identifier", ]]
        }
    },
    indent = {
        enable = true,
        disable = { "yaml" }
    },
    refactor = {
        highlight_definitions = {
            enable = false,
            -- Set to false if you have an `updatetime` of ~100.
            clear_on_cursor_move = true,
        },
        smart_rename = {
            enable = false,
            keymaps = {
                smart_rename = "grn",
            },
        },
    },
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
    }
}
