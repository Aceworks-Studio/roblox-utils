local JestGlobals = require('@pkg/@jsdotlua/jest-globals')

local createBoolean = require('../boolean')

local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeAll = JestGlobals.beforeAll

local FUZZ_COUNT = 20

local generator

beforeAll(function()
    generator = createBoolean(Random.new())
end)

it('returns a boolean when called', function()
    for i = 1, FUZZ_COUNT do
        expect(generator()).toEqual(expect.any('boolean'))
    end
end)

it('returns a boolean when called with a chance', function()
    for i = 1, FUZZ_COUNT do
        expect(generator(0.1)).toEqual(expect.any('boolean'))
    end
end)
