local embedded_sql = vim.treesitter.parse_query(
    "python",
    [[
    (call
        function: (attribute
            attribute: (identifier) @fname (#eq? @fname "execute")
        )
        arguments: (argument_list
            (string) @sql
        )
    )
    ]]
)


local function format_sql()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.bo[bufnr].filetype ~= "python" then
        return
    end
    local root = vim.treesitter.get_parser(bufnr, "python", {}):parse()[1]:root()
    local changes = {}
    for id, node in embedded_sql:iter_captures(root, bufnr, 0, -1) do
        local name = embedded_sql.captures[id]
        if name == "sql" then
            local range = {node:range()}
            local indent = string.rep(" ", range[2] + 2)
            local raw_sql = vim.treesitter.get_node_text(node, bufnr)
            local formatted_string = vim.fn.system("python ~/repos/test/sqlformat.py", raw_sql)
            if formatted_string == "ERROR" then
                return
            end
            local formatted_sql = vim.split(formatted_string, "\n")
            if #vim.split(raw_sql, "\n") == 1 then
                local original_line = vim.api.nvim_buf_get_lines(bufnr, range[1], range[1] + 1, false)[1]
                local substring = ""
                if #formatted_sql > 1 then
                    table.insert(formatted_sql, 1, [["""]])
                    table.insert(formatted_sql, 1, "")
                    table.insert(formatted_sql, [["""]])
                    table.insert(formatted_sql, "")
                    for idx, line in ipairs(formatted_sql) do
                        if idx ~= #formatted_sql and vim.trim(line) ~= "" then
                            if idx > 2 and idx < #formatted_sql - 1 then
                                formatted_sql[idx] = string.rep(" ", vim.opt.shiftwidth:get() + 2) .. line
                            else
                                formatted_sql[idx] = string.rep(" ", vim.opt.shiftwidth:get()) .. line
                            end
                        end
                    end
                    substring = table.concat(formatted_sql, "\n")
                else
                    substring = "\"" .. formatted_sql[1] .. "\""
                end
                local formatted_line = string.gsub(original_line, [[".*"]], substring)
                formatted_sql = vim.split(formatted_line, "\n")
                table.insert(changes, 1, {
                    start = range[1],
                    finish = range[1] + 1,
                    formatted_sql = formatted_sql
                })
            else
                -- add indentation
                for idx, line in ipairs(formatted_sql) do
                    if vim.trim(line) ~= "" then
                        formatted_sql[idx] = indent .. line
                    end
                end
                table.insert(changes, 1, {
                    start = range[1] + 1,
                    finish = range[3],
                    formatted_sql = formatted_sql
                })
            end
        end
    end

    for _, change in ipairs(changes) do
        vim.api.nvim_buf_set_lines(bufnr, change.start, change.finish, false, change.formatted_sql)
    end
end

vim.api.nvim_create_user_command("FormatSql", format_sql, {})

vim.api.nvim_create_augroup("FormatSql", {})
vim.api.nvim_create_autocmd( "BufWritePre", {
    group = "FormatSql",
    pattern = "*.py",
    callback = format_sql
})
