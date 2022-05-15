vim.g.dashboard_custom_header = {
    '███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
    '████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
    '██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
    '██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
    '██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
    '╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
}

vim.g.dashboard_custom_footer = {

}

vim.g.dashboard_default_executive='telescope'

vim.g.dashboard_custom_section = {
    projects = {
        description = {'Open Projects'},
        command = 'Telescope project',
    },
    recent = {
        description= {'Open Recent Files'},
        command = 'Telescope oldfiles'
    },
    z_colorscheme = {
        description = {'Change Colorscheme'},
        command = 'Telescope colorscheme'
    },
}

vim.g.dashboard_custom_shortcut={
    ['last_session']       = '',
    ['find_history']       = '',
    ['find_file']          = '',
    ['new_file']           = '',
    ['change_colorscheme'] = '',
    ['find_word']          = '',
    ['book_marks']         = '',
}

