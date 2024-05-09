local isNaN = require('../isNaN')

local JestGlobals = require('@pkg/@jsdotlua/jest-globals')
local expect = JestGlobals.expect
local it = JestGlobals.it

it('returns true when given 0/0', function()
    expect(isNaN(0 / 0)).toEqual(true)
end)
it('returns true when given -0/0', function()
    expect(isNaN(-0 / 0)).toEqual(true)
end)

it.each({ 0, 1, -1, 100, -987, 1e6, math.huge, -math.huge })('returns false for %p', function(value)
    expect(isNaN(value)).toEqual(false)
end)
