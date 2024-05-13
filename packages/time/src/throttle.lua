local function throttle<R..., T...>(durationSeconds: number, fn: (T...) -> R...): (T...) -> ()
    if durationSeconds <= 0 then
        return fn :: any
    end

    local lastCall: number? = nil
    local scheduled = false

    local function throttled(...: T...)
        local currentTime = os.clock()
        local deltaTime = lastCall and currentTime - lastCall

        if deltaTime == nil or deltaTime >= durationSeconds then
            lastCall = currentTime
            fn(...)
        elseif not scheduled then
            scheduled = true
            task.delay(durationSeconds - deltaTime :: number, function(...)
                scheduled = false
                fn(...)
            end, ...)
        end
    end

    return throttled
end

return throttle
