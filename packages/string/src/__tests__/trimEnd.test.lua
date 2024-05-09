local trimEnd = require('../trimEnd')

local JestGlobals = require('@pkg/@jsdotlua/jest-globals')
local expect = JestGlobals.expect
local it = JestGlobals.it

it('does not remove spaces at beginning', function()
    expect(trimEnd('  abc')).toEqual('  abc')
end)

it('removes spaces at end', function()
    expect(trimEnd('abc   ')).toEqual('abc')
end)

it('removes spaces at only at end', function()
    expect(trimEnd('  abc   ')).toEqual('  abc')
end)

it('does not remove spaces in the middle', function()
    expect(trimEnd('a b c')).toEqual('a b c')
end)

it('removes all types of spaces', function()
    expect(trimEnd('abc\r\n\t\f\v')).toEqual('abc')
end)

it('returns an empty string if there are only spaces', function()
    expect(trimEnd('    ')).toEqual('')
end)
