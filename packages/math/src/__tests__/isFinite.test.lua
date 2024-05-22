local isFinite = require('../isFinite')

local JestGlobals = require('@pkg/@jsdotlua/jest-globals')
local expect = JestGlobals.expect
local it = JestGlobals.it
local each: <T>({ T }) -> (string, (T) -> ()) -> () = it.each :: any

local trueValues = { 0, 1, 0.5, math.pi, 1e64, -4, -123456 }
local falseValues = {
    math.huge,
    0 / 0,
    -math.huge,
}

each(trueValues)('returns true for %p', function(value)
    expect(isFinite(value)).toEqual(true)
end)

each(falseValues)('returns false for %p', function(value)
    expect(isFinite(value)).toEqual(false)
end)
