if vim.fn.has("mac") == 1 then
    vim.g.python3_host_prog = '/opt/homebrew/bin/python'
else
    vim.g.python3_host_prog = '/usr/bin/python3'
end

local options = {
    showmode = false,
    backup = false,                          -- creates a backup file
    clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
    -- colorcolumn = '120',                     -- draws a line at column n
    cmdheight = 2,                           -- more space in the neovim command line for displaying messages
    completeopt = { "menuone", "noselect" }, -- mostly just for cmp
    conceallevel = 0,                        -- so that `` is visible in markdown files
    encoding = "utf-8",                      -- the encoding written to a file
    foldmethod = "expr",                     -- Treesitter based folding
    foldexpr = "nvim_treesitter#foldexpr()", -- TreeSitter based folding
    foldlevel = 100000,                      -- Level after which foldings are closed
    -- hlsearch = true,                         -- highlight all matches on previous search pattern
    ignorecase = true,                       -- ignore case in search patterns
    mouse = "a",                             -- allow the mouse to be used in neovim
    pumheight = 30,                          -- pop up menu height
    showtabline = 0,                         -- No tabline
    smartcase = true,                        -- smart case
    smartindent = true,                      -- make indenting smarter again
    splitbelow = true,                       -- force all horizontal splits to go below current window
    splitright = true,                       -- force all vertical splits to go to the right of current window
    swapfile = false,                        -- creates a swapfile
    termguicolors = true,                    -- set term gui colors (most terminals support this)
    timeoutlen = 500,                        -- time to wait for a mapped sequence to complete (in milliseconds)
    title = true,                            -- set the title of window to the value of the titlestring
    titlestring = "nvim - %t",               -- what the title of the window will be set to
    undofile = true,                         -- persistent undo
    updatetime = 100,                        -- faster completion (4000ms default)
    writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    expandtab = true,                        -- convert tabs to spaces
    shiftwidth = 4,                          -- the number of spaces inserted for each indentation
    tabstop = 4,                             -- insert 2 spaces for a tab
    cursorline = true,                       -- highlight the current line
    number = true,                           -- set numbered lines
    relativenumber = true,                   -- set relative numbered lines
    numberwidth = 4,                         -- set number column width to 2 {default 4}
    signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
    wrap = false,                            -- display lines as one long line
    scrolloff = 8,                           -- scroll 8 lines from end of screen
    sidescrolloff = 8,                       -- scroll 8 columns from edge of screen
    -- spell = true,
    -- spelllang = {'en_us'}
    -- guifont = "monospace:h17",               -- the font used in graphical neovim applications
}

vim.opt.shortmess:append("c")
vim.filetype.add({
    extension = {
        rasi = "rasi",
        keymap = "c"
    }
})

for k, v in pairs(options) do
    vim.opt[k] = v
end

