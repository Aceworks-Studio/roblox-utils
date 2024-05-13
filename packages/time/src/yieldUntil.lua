local loopUntil = require('./loopUntil')

type Interval = loopUntil.Interval
type LoopConfig = loopUntil.LoopConfig

local function yieldUntil(interval: Interval, fn: (deltaTime: number) -> boolean)
    local shouldContinue = true

    local isConfig = type(interval) ~= 'number'
    local intervalTime = if isConfig then (interval :: LoopConfig).interval else interval :: number
    local timeLeft = if isConfig then (interval :: LoopConfig).duration or math.huge else math.huge

    local waitedTime = task.wait(intervalTime)
    timeLeft -= waitedTime

    while shouldContinue and timeLeft > 0 do
        shouldContinue = fn(waitedTime)
        waitedTime = task.wait(intervalTime)
        timeLeft -= waitedTime
    end
end

return yieldUntil
