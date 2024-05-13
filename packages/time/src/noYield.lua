local function noYield<T..., R...>(fn: (T...) -> R..., ...: T...): R...
    if _G.DEV then
        local thread = coroutine.create(fn)

        local results = table.pack(coroutine.resume(thread, ...))

        local success = results[1]
        if not success then
            local err = results[2]

            local message = if typeof(err) == 'string'
                then debug.traceback(thread, err)
                else tostring(err)

            error(message, 2)
        end

        if coroutine.status(thread) ~= 'dead' then
            error(debug.traceback(thread, 'function is not allowed to yield'), 2)
        end

        return table.unpack(results :: any, 2)
    else
        return fn(...)
    end
end

return noYield
