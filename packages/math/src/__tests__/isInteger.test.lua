--!nolint IntegerParsing
local isInteger = require('../isInteger')

local JestGlobals = require('@pkg/@jsdotlua/jest-globals')
local expect = JestGlobals.expect
local it = JestGlobals.it
local each: <T>({ T }) -> (string, (T) -> ()) -> () = it.each :: any

local trueValues = { 0, 1, -100000, 99999999999999999999999, 5.0 }
local falseValues = { 0.1, -0.5, math.pi, math.huge, 0 / 0, -math.huge }

each(trueValues)('returns true for %p', function(value)
    expect(isInteger(value)).toEqual(true)
end)

each(falseValues)('returns false for %p', function(value)
    expect(isInteger(value)).toEqual(false)
end)
