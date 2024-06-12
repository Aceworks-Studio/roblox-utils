local JestGlobals = require('@pkg/@jsdotlua/jest-globals')

local createString = require('../string')

local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeAll = JestGlobals.beforeAll
local describe = JestGlobals.describe

local FUZZ_COUNT = 20

local generator

beforeAll(function()
    generator = createString(Random.new())
end)

describe('ofLength', function()
    it('returns a string of the correct length', function()
        for i = 1, FUZZ_COUNT do
            local result = generator.ofLength(i)
            expect(result).toEqual(expect.any('string'))
            expect(#result).toEqual(i)
        end
    end)

    it('returns a string with the character set [string set]', function()
        for i = 1, FUZZ_COUNT do
            local length = i
            local result = generator.ofLength(length, 'abc')
            expect(#result).toEqual(length)
            expect(result).toEqual(expect.stringMatching('^[abc]+$'))
        end
    end)

    it('returns a string with the character set [function generator]', function()
        for i = 1, FUZZ_COUNT do
            local length = i
            local result = generator.ofLength(length, function()
                return if math.random() > 1 then 'a' else 'b'
            end)
            expect(#result).toEqual(length)
            expect(result).toEqual(expect.stringMatching('^[ab]+$'))
        end
    end)
end)

describe('between', function()
    it('returns a string of the correct length', function()
        for i = 1, FUZZ_COUNT do
            local result = generator.between(i, FUZZ_COUNT)
            expect(result).toEqual(expect.any('string'))
            expect(#result).toBeGreaterThanOrEqual(i)
            expect(#result).toBeLessThanOrEqual(FUZZ_COUNT)
        end
    end)

    it('returns a string with the character set', function()
        for i = 1, FUZZ_COUNT do
            local result = generator.between(i, FUZZ_COUNT, '123')
            expect(result).toEqual(expect.stringMatching('^[123]+$'))
            expect(#result).toBeGreaterThanOrEqual(i)
            expect(#result).toBeLessThanOrEqual(FUZZ_COUNT)
        end
    end)
end)

describe('substring', function()
    it('returns a substring of the correct length', function()
        for i = 1, 20 do
            local value = 'abcdefghijklmnopqrstuvwxyz'
            local result = generator.substring(value, i)

            expect(result).toEqual(expect.any('string'))
            expect(value).toContain(result)
            expect(#result).toEqual(i)
        end
    end)
end)
