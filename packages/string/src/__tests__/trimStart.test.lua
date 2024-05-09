local trimStart = require('../trimStart')

local JestGlobals = require('@pkg/@jsdotlua/jest-globals')
local expect = JestGlobals.expect
local it = JestGlobals.it

it('removes spaces at beginning', function()
    expect(trimStart('  abc')).toEqual('abc')
end)

it('does not remove spaces at end', function()
    expect(trimStart('abc   ')).toEqual('abc   ')
end)

it('removes spaces at only at beginning', function()
    expect(trimStart('  abc   ')).toEqual('abc   ')
end)

it('does not remove spaces in the middle', function()
    expect(trimStart('a b c')).toEqual('a b c')
end)

it('removes all types of spaces', function()
    expect(trimStart('\r\n\t\f\vabc')).toEqual('abc')
end)

it('returns an empty string if there are only spaces', function()
    expect(trimStart('    ')).toEqual('')
end)
