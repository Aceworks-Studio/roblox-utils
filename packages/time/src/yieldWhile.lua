local yieldUntil = require('./yieldUntil')

export type Interval = yieldUntil.Interval
export type LoopConfig = yieldUntil.LoopConfig

local function yieldWhile(interval: Interval, fn: (deltaTime: number) -> boolean)
    yieldUntil(interval, function(deltaTime)
        return not fn(deltaTime)
    end)
end

return yieldWhile
