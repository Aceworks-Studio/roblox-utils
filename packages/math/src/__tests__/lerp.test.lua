local lerp = require('../lerp')

local JestGlobals = require('@pkg/@jsdotlua/jest-globals')
local expect = JestGlobals.expect
local it = JestGlobals.it

it('gives the initial value when alpha is at 0', function()
    expect(lerp(1, 10, 0)).toBe(1)
end)

it('gives the final value when alpha is at 1', function()
    expect(lerp(5, 10, 1)).toBe(10)
end)

it('gives the middle value when alpha is at 0.5', function()
    expect(lerp(1, 2, 0.5)).toBe(1.5)
end)
