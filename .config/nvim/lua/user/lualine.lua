local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	vim.notify("Lualine Not Found")
	return
end

local function indent_width()
    return (vim.api.nvim_buf_get_option(0, "shiftwidth")) or ""
end

local navic_location = {
    function()
        local nv_status, navic = pcall(require, "nvim-navic")
        if not nv_status then
            return ""
        end
        local location = navic.get_location()
        if location == nil or location == "" or location == "Error" then
            return ""
        end
        return location
    end,
}

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		-- section_separators = { left = '', right = ''},
		disabled_filetypes = {
            winbar = {"NvimTree", "dap-repl", "dapui_scopes", "dapui_watches", "dapui_stacks", "dapui_breakpoints", "dapui_expressions", "dapui_locals", "dapui_repl", "dapui_sessions", "dapui_stopped_threads", "dapui_widgets", "dapui_win"}
        },
		always_divide_middle = true,
		globalstatus = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "os.date('%H:%M')" },
		lualine_x = { indent_width, "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {},
	winbar = {
		lualine_a = { "filename" },
        lualine_b = {},
		lualine_c = { navic_location },
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	inactive_winbar = {
		lualine_a = { "filename" },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	extensions = {
		"nvim-tree",
		"quickfix",
		"toggleterm",
		"fugitive",
        "nvim-dap-ui",
	},
})
