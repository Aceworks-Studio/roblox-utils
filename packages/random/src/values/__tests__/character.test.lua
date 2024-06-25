local JestGlobals = require('@pkg/@jsdotlua/jest-globals')

local createCharacter = require('../character')

local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeAll = JestGlobals.beforeAll

local FUZZ_COUNT = 20

local generator

beforeAll(function()
    generator = createCharacter(Random.new())
end)

it('returns a valid digit', function()
    for _ = 1, FUZZ_COUNT do
        expect(generator.digit()).toEqual(expect.stringMatching('^[0-9]$'))
    end
end)

it('returns a valid letter', function()
    for _ = 1, FUZZ_COUNT do
        expect(generator.letter()).toEqual(expect.stringMatching('^[a-zA-Z]$'))
    end
end)

it('returns a valid lower case letter', function()
    for _ = 1, FUZZ_COUNT do
        expect(generator.lowerCaseLetter()).toEqual(expect.stringMatching('^[a-z]$'))
    end
end)

it('returns a valid upper case letter', function()
    for _ = 1, FUZZ_COUNT do
        expect(generator.upperCaseLetter()).toEqual(expect.stringMatching('^[A-Z]$'))
    end
end)
