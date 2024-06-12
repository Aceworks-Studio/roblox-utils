local isFinite = require('./isFinite')
local isInteger = require('./isInteger')
local isNaN = require('./isNaN')
local lerp = require('./lerp')
local limits = require('./limits')
local round = require('./round')

return {
    isFinite = isFinite,
    isInteger = isInteger,
    isNaN = isNaN,
    lerp = lerp,
    round = round,

    isSafeInteger = limits.isSafeInteger,
    maxInteger = limits.maxInteger,
    minInteger = limits.minInteger,
}
