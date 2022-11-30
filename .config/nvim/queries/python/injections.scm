(call
    function: (attribute
        attribute: (identifier) @_fname (#eq? @_fname "execute")
    )
    arguments: (argument_list
        (string) @sql
    )
)
(assignment
    ; Check if the variable ends with "query"
    left: (identifier) @_vnamee (#match? @_vnamee ".*query$")
    right: (string) @sql
)

