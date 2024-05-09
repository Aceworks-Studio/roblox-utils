local function debounce<R, T...>(durationSeconds: number, fn: (T...) -> R): (T...) -> R?
    if durationSeconds <= 0 then
        return fn
    end

    local canRun = true

    local function debounced(...: T...): R?
        if not canRun then
            return nil
        end
        canRun = false

        task.delay(durationSeconds, function()
            canRun = true
        end)

        return fn(...)
    end

    return debounced
end

return debounce
