local debounce = require('./debounce')
local loopUntil = require('./loopUntil')
local loopWhile = require('./loopWhile')
local noYield = require('./noYield')
local throttle = require('./throttle')
local yieldUntil = require('./yieldUntil')

export type Interval = loopUntil.Interval

return {
    debounce = debounce,
    loopUntil = loopUntil,
    loopWhile = loopWhile,
    noYield = noYield,
    throttle = throttle,
    yieldUntil = yieldUntil,
}
