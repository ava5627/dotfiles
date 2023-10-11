local M = {}

M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = false,
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

local function lsp_highlight_document(client)
	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_create_augroup("lsp_document_highlight", {})
		vim.api.nvim_create_autocmd("CursorHold", {
			pattern = "<buffer>",
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			pattern = "<buffer>",
			callback = vim.lsp.buf.clear_references,
		})
	end
end

local function lsp_keymaps(bufnr)
	local function opts(desc)
		return { desc = desc, buffer = bufnr, noremap = true, silent = true }
	end
	local ts_status, telescope = pcall(require, "telescope.builtin")
	if ts_status then
		vim.keymap.set("n", "gd", telescope.lsp_definitions, opts("Go to definition"))
		vim.keymap.set("n", "gi", telescope.lsp_implementations, opts("Go to implementation"))
		vim.keymap.set("n", "grf", telescope.lsp_references, opts("Go to references"))
		vim.keymap.set("n", "<leader>gc", telescope.diagnostics, opts("Go to diagnostics"))
	else
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
		vim.keymap.set("n", "grf", vim.lsp.buf.references, opts("Go to references"))
		vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts("Go to type definition"))
		vim.keymap.set("n", "<leader>gc", vim.diagnostic.setqflist, opts("Go to diagnostics"))
	end
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
	vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts("Hover"))
	if vim.bo.filetype == "rust" then
		vim.keymap.set("n", "gh", "<cmd>RustHoverActions<CR>", opts("Hover"))
		vim.keymap.set("v", "gh", "<cmd>RustHoverRange<CR>", opts("Hover"))
	end
	if vim.bo.filetype ~= "tex" then
		vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, opts("Signature help"))
	end
	vim.keymap.set("i", "<C-g><C-k>", vim.lsp.buf.signature_help, opts("Signature help"))
	vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts("Rename"))
	vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts("Code actions"))
	vim.keymap.set({ "i", "n", "v" }, "<A-return>", vim.lsp.buf.code_action, opts("Code actions"))
	-- vim.keymap.set("n", "<leader>f", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_prev({ border = "rounded" })
	end, opts("Go to previous diagnostic"))
	vim.keymap.set("n", "gl", function()
		vim.diagnostic.open_float({ border = "rounded" })
	end, opts("Open diagnostic window"))
	-- vim.keymap.set("n", "gs", vim.diagnostic.show, opts)
	-- vim.keymap.set("n", "gh", vim.diagnostic.hide, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_next({ border = "rounded" })
	end, opts("Go to next diagnostic"))
	vim.keymap.set("n", "<A-f>", vim.lsp.buf.format, opts("Format"))
	vim.keymap.set("n", "gv", function()
		local vt = vim.diagnostic.config()["virtual_text"]
		vim.diagnostic.config({ virtual_text = not vt })
	end, opts("Toggle virtual text"))
end

M.on_attach = function(client, bufnr)
	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end

	lsp_keymaps(bufnr)
	lsp_highlight_document(client)

	if client.server_capabilities.documentSymbolProvider then
		local _, navic = pcall(require, "nvim-navic")
		navic.attach(client, bufnr)
	end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
	return
end

M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

return M
