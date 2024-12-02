local loopUntil = require('./loopUntil')

export type Interval = loopUntil.Interval
export type LoopConfig = loopUntil.LoopConfig

local function yieldUntil(interval: Interval, fn: (deltaTime: number) -> boolean)
    local shouldStop = false

    local isConfig = type(interval) ~= 'number'
    local intervalTime = if isConfig then (interval :: LoopConfig).interval else interval :: number
    local timeLeft = if isConfig then (interval :: LoopConfig).duration or math.huge else math.huge

    local waitedTime = task.wait(intervalTime)
    timeLeft -= waitedTime

    while timeLeft > 0 do
        shouldStop = fn(waitedTime)

        if shouldStop then
            break
        end

        waitedTime = task.wait(intervalTime)
        timeLeft -= waitedTime
    end
end

return yieldUntil
