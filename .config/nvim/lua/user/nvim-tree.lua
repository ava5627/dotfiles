-- each of these are documented in `:help nvim-tree.OPTION_NAME`

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    vim.notify("Nvim Tree Not Found")
    return
end

local function on_attach(bufnr)
    local nt_api_ok, nt_api = pcall(require, "nvim-tree.api")
    if not nt_api_ok then
        vim.notify("Nvim Tree API Not Found")
        return
    end
    local function opts(desc)
        return { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    nt_api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set("n", "l", nt_api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "v", nt_api.node.open.vertical, opts("Open Vertical Split"))
    vim.keymap.set("n", "s", nt_api.node.open.horizontal, opts("Open Horizontal Split"))
    vim.keymap.set("n", "h", nt_api.node.navigate.parent_close, opts("Close"))
    vim.keymap.set("n", "<BS>", "<leader>", { desc = "Backspace leader", buffer = bufnr, remap = true, silent = true, nowait = true })
    vim.keymap.set("n", "]d", nt_api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
    vim.keymap.set("n", "[d", nt_api.node.navigate.diagnostics.prev, opts("Previous Diagnostic"))
end

nvim_tree.setup({
    auto_reload_on_write = true,
    disable_netrw = false,
    hijack_cursor = true,
    hijack_netrw = true,
    hijack_unnamed_buffer_when_opening = false,
    open_on_tab = false,
    sort_by = "name",
    sync_root_with_cwd = true,
    on_attach = on_attach,
    view = {
        width = 30,
        side = "left",
        preserve_window_proportions = false,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
    },
    renderer = {
        add_trailing = false,
        group_empty = true,
        highlight_git = false,
        highlight_opened_files = "none",
        root_folder_modifier = ":~",
        indent_markers = {
            enable = true,
            inline_arrows = true,
            icons = {
                corner = "└",
                edge = "│",
                none = " ",
            },
        },
        icons = {
            webdev_colors = true,
            git_placement = "after",
            padding = " ",
            symlink_arrow = " ➛ ",
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                default = "󰈔",
                symlink = "",
                git = {
                    unstaged = "●",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★",
                    deleted = "",
                    ignored = "●",
                },
                folder = {
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                },
            },
        },
        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
    },
    hijack_directories = {
        enable = true,
        auto_open = true,
    },
    update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = { "gitcommit", "COMMIT_EDITMSG" },
    },
    system_open = {
        cmd = nil,
        args = {},
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    filters = {
        dotfiles = false,
        custom = {},
        exclude = {},
    },
    git = {
        enable = true,
        ignore = true,
        timeout = 400,
    },
    filesystem_watchers = {
        enable = true,
        debounce_delay = 150,
        ignore_dirs = {
            "/home/ava/.git",
        },
    },
    actions = {
        change_dir = {
            enable = true,
            global = false,
        },
        open_file = {
            quit_on_open = false,
            resize_window = true,
            window_picker = {
                enable = true,
                chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                exclude = {
                    filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                    buftype = { "nofile", "terminal", "help" },
                },
            },
        },
    },
    trash = {
        cmd = "gio trash",
        require_confirm = true,
    },
    log = {
        enable = false,
        truncate = false,
        types = {
            all = false,
            config = false,
            copy_paste = false,
            git = false,
            profile = false,
            watcher = false,
        },
    },
}) -- END_DEFAULT_OPTS
