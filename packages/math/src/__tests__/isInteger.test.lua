--!nolint IntegerParsing
local isInteger = require('../isInteger')

local JestGlobals = require('@pkg/@jsdotlua/jest-globals')
local expect = JestGlobals.expect
local it = JestGlobals.it

it('returns true when given 0', function()
    expect(isInteger(0)).toEqual(true)
end)

it('returns true when given 1', function()
    expect(isInteger(1)).toEqual(true)
end)

it('returns true when given -100000', function()
    expect(isInteger(-100000)).toEqual(true)
end)

it('returns true when given 99999999999999999999999', function()
    expect(isInteger(99999999999999999999999)).toEqual(true)
end)

it('returns true when given 5.0', function()
    expect(isInteger(5.0)).toEqual(true)
end)

it('returns false when given 0.1', function()
    expect(isInteger(0.1)).toEqual(false)
end)

it('returns false when given math.pi', function()
    expect(isInteger(math.pi)).toEqual(false)
end)

it('returns false when given nan', function()
    expect(isInteger(0 / 0)).toEqual(false)
end)

it('returns false when given infinity', function()
    expect(isInteger(math.huge)).toEqual(false)
end)

it('returns false when given -infinity', function()
    expect(isInteger(-math.huge)).toEqual(false)
end)
