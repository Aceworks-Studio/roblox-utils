local isFinite = require('../isFinite')

local JestGlobals = require('@pkg/@jsdotlua/jest-globals')
local expect = JestGlobals.expect
local it = JestGlobals.it

local trueValues = { 0, 1, 1e64, -4, -123456 }
local falseValues = {
    math.huge,
    0 / 0,
    -math.huge,
}

it.each(trueValues)('returns true for %p', function(value)
    expect(isFinite(value)).toEqual(true)
end)

it.each(falseValues)('returns false for %p', function(value)
    expect(isFinite(value)).toEqual(false)
end)
