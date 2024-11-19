local RefreshScheduler = require('./RefreshScheduler')
local debounce = require('./debounce')
local loopUntil = require('./loopUntil')
local loopWhile = require('./loopWhile')
local noYield = require('./noYield')
local throttle = require('./throttle')
local yieldUntil = require('./yieldUntil')

export type RefreshScheduler<Request, Result> = RefreshScheduler.RefreshScheduler<Request, Result>
export type RefreshSchedulerOptions<Request> = RefreshScheduler.RefreshSchedulerOptions<Request>
export type Interval = loopUntil.Interval

return {
    RefreshScheduler = RefreshScheduler,
    debounce = debounce,
    loopUntil = loopUntil,
    loopWhile = loopWhile,
    noYield = noYield,
    throttle = throttle,
    yieldUntil = yieldUntil,
}
