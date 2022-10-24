(call
    function: (attribute
        attribute: (identifier) @_fname (#eq? @_fname "execute")
    )
    arguments: (argument_list
        (string) @sql
    )
)
(assignment
    left: (identifier) @_vnamee (#eq? @_vnamee "sql_query")
    right: (string) @sql
)
(assignment
    left: (identifier) @_vnamee2 (#eq? @_vnamee2 "query")
    right: (string) @sql
)

