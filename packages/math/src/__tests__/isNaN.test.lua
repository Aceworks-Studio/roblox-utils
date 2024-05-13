local isNaN = require('../isNaN')

local JestGlobals = require('@pkg/@jsdotlua/jest-globals')
local expect = JestGlobals.expect
local it = JestGlobals.it
local each: <T>({ T }) -> (string, (T) -> ()) -> () = it.each :: any

it('returns true when given 0/0', function()
    -- selene: allow(divide_by_zero)
    expect(isNaN(0 / 0)).toEqual(true)
end)

it('returns true when given -0/0', function()
    -- selene: allow(divide_by_zero)
    expect(isNaN(-0 / 0)).toEqual(true)
end)

each({ 0, 1, -1, 100, -987, 1e6, math.huge, -math.huge })('returns false for %p', function(value)
    expect(isNaN(value)).toEqual(false)
end)
