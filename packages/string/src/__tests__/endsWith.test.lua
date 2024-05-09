local endsWith = require('../endsWith')

local JestGlobals = require('@pkg/@jsdotlua/jest-globals')
local expect = JestGlobals.expect
local it = JestGlobals.it

it('is true if the string ends with the given substring', function()
    expect(endsWith('oof', 'of')).toEqual(true)
end)

it('is false if the string does not end with the given substring', function()
    expect(endsWith('oof', 'b')).toEqual(false)
end)

it('is false if the substring is longer than the string', function()
    expect(endsWith('ooo', 'oooo')).toEqual(false)
end)

it('is true if the substring is empty', function()
    expect(endsWith('oof', '')).toEqual(true)
end)

it('is true if the substring is empty and the value too', function()
    expect(endsWith('', '')).toEqual(true)
end)
