local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
    vim.api.nvim_err_writeln("DAP not found")
    return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
    vim.api.nvim_err_writeln("DAPUI not found")
    return
end

local dap_install_status_ok, dap_install = pcall(require, "dap-install")
if not dap_install_status_ok then
    vim.api.nvim_err_writeln("DAP-Install not found")
    return
end

local dap_virt_text_status_ok, dap_virt_text = pcall(require, "nvim-dap-virtual-text")
if not dap_virt_text_status_ok then
    vim.api.nvim_err_writeln("nvim-dap-virtual-text not found")
    return
end

dap_install.setup {}

dap_install.config("python", {})
dap_install.config("go_delve", {})
dap_install.config("ccppr_lldb", {})

dapui.setup({
    icons = { expanded = "▾", collapsed = "▸" },
    mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    -- Expand lines larger than the window
    -- Requires >= 0.7
    expand_lines = vim.fn.has("nvim-0.7"),
    -- Layouts define sections of the screen to place windows.
    -- The position can be "left", "right", "top" or "bottom".
    -- The size specifies the height/width depending on position. It can be an Int
    -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
    -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
    -- Elements are the elements shown in the layout (in order).
    -- Layouts are opened in order so that earlier layouts take priority in window sizing.
    layouts = {
        {
            elements = {
                -- Elements can be strings or table with id and size keys.
                { id = "scopes", size = 0.25 },
                "watches",
                "breakpoints",
                "stacks",
            },
            size = .25, -- 100 columns
            position = "left",
        },
        {
            elements = {
                {id = "repl", size = .5},
                {id = "console", size = .5},
            },
            size = 0.25, -- 25% of total lines
            position = "bottom",
        },
    },
    floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = "single", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    windows = { indent = 1 },
    render = {
        max_type_length = nil, -- Can be integer or nil.
    }
})

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })

dap_virt_text.setup({})

dap.listeners.after.event_initialized["dapui_config"] = function()
    local tree_ok, tree = pcall(require, "nvim-tree.api")
    if tree_ok then
        tree.tree.close()
    end
    dapui.open({})
end

dap.listeners.after.event_terminated["dapui_config"] = function()
    dapui.close({})
    local tree_ok, tree = pcall(require, "nvim-tree.api")
    if tree_ok then
        tree.tree.toggle({ focus = false })
    end
end

dap.listeners.after.event_exited["dapui_config"] = function()
    dapui.close({})
end
