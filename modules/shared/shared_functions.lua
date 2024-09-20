local SHARED = {}


-- [[ Debug Value/Table]]
SHARED.DebugData = function(...)
    if Config.CoreInfo.EnableDebug then
        local args = { ... }
        for i, arg in ipairs(args) do
            if type(arg) == 'table' then
                args[i] = json.encode(arg, { sort_keys = true, indent = true })
            else
                args[i] = '^0' .. tostring(arg)
            end
        end

        local formattedMessage = '^5[DEBUG] ^7' .. table.concat(args, '\t')
        print(formattedMessage)
    end
end


-- [[ Trim String]]
SHARED.TrimString = function(string)
    return string:match("^%s*(.-)%s*$")
end




return SHARED

