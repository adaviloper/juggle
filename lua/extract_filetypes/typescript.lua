local M = {}

M.variable = {
    format = "const %s = %s;"
}

M.prep_variable = function(var_name)
    return var_name
end

return M
