local contains = require('../contains')

local JestGlobals = require('@pkg/@jsdotlua/jest-globals')
local expect = JestGlobals.expect
local it = JestGlobals.it

it('is true if the string ends with the given substring', function()
    expect(contains('oof', 'of')).toEqual(true)
end)

it('is false if the string does not end with the given substring', function()
    expect(contains('oof', 'b')).toEqual(false)
end)

it('is false if the substring is longer than the string', function()
    expect(contains('ooo', 'oooo')).toEqual(false)
end)

it('is true if the substring is empty', function()
    expect(contains('oof', '')).toEqual(true)
end)

it('is true if the substring is empty and the value too', function()
    expect(contains('', '')).toEqual(true)
end)

it('is true if the string starts with the given substring', function()
    expect(contains('oof', 'oo')).toEqual(true)
end)

it('is true if the string contains the substring', function()
    expect(contains('abc', 'c')).toEqual(true)
end)
