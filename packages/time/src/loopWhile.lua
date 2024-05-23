local loopUntil = require('./loopUntil')

type Interval = loopUntil.Interval

local function loopWhile(interval: Interval, fn: (deltaTime: number) -> boolean): () -> ()
    return loopUntil(interval, function(deltaTime)
        return not fn(deltaTime)
    end)
end

return loopWhile
