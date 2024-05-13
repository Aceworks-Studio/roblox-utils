type LoopConfig = { interval: number, duration: number? }
export type Interval = number | LoopConfig

local function loopUntil(interval: Interval, fn: (deltaTime: number) -> boolean): () -> ()
    local shouldContinue = true

    local isConfig = type(interval) ~= 'number'
    local intervalTime = if isConfig then (interval :: LoopConfig).interval else interval :: number
    local timeLeft = if isConfig then (interval :: LoopConfig).duration or math.huge else math.huge

    local currentThread = task.spawn(function()
        local waitedTime = task.wait(intervalTime)
        timeLeft -= waitedTime

        while shouldContinue and timeLeft > 0 do
            shouldContinue = fn(waitedTime)
            waitedTime = task.wait(intervalTime)
            timeLeft -= waitedTime
        end
    end)

    local function cancel()
        shouldContinue = false
        task.cancel(currentThread)
    end

    return cancel
end

return loopUntil
