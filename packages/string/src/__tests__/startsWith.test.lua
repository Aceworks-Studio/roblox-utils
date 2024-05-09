local startsWith = require('../startsWith')

local JestGlobals = require('@pkg/@jsdotlua/jest-globals')
local expect = JestGlobals.expect
local it = JestGlobals.it

it('is true if the string starts with the given substring', function()
    expect(startsWith('oof', 'oo')).toEqual(true)
end)

it('is false if the string does not start with the given substring', function()
    expect(startsWith('oof', 'b')).toEqual(false)
end)

it('is true if the substring is empty', function()
    expect(startsWith('oof', '')).toEqual(true)
end)
