local JestGlobals = require('@pkg/@jsdotlua/jest-globals')

local createArray = require('../array')
local createString = require('../values/string')

local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeAll = JestGlobals.beforeAll
local describe = JestGlobals.describe

local FUZZ_COUNT = 20

local generator
local stringGenerator

beforeAll(function()
    generator = createArray(Random.new())
    stringGenerator = createString(Random.new())
end)

local function generateTrue()
    return true
end

describe('ofLength', function()
    it('returns an array of the correct length', function()
        for i = 1, FUZZ_COUNT do
            local result = generator.ofLength(i, generateTrue)

            expect(result).toEqual(table.create(i, true))
        end
    end)
end)

describe('between', function()
    it('returns an array of the correct length', function()
        for i = 1, FUZZ_COUNT do
            local result = generator.between(i, FUZZ_COUNT, generateTrue)

            expect(#result).toBeGreaterThanOrEqual(i)
            expect(#result).toBeLessThanOrEqual(FUZZ_COUNT)
        end
    end)

    it('returns an array with the correct content', function()
        for i = 1, FUZZ_COUNT do
            local result = generator.between(i, FUZZ_COUNT, generateTrue)

            for _, element in result do
                expect(element).toEqual(true)
            end
        end
    end)
end)

local function generateString()
    return stringGenerator.ofLength(16)
end

describe('shuffle', function()
    it('returns an array of the correct length with the same content', function()
        for i = 1, FUZZ_COUNT do
            local original = generator.ofLength(i, generateString)

            local mixed = generator.shuffle(original)

            expect(#mixed).toEqual(i)

            for _, item in original do
                local index = table.find(mixed, item)
                expect(index).toBeDefined()
                table.remove(mixed, index)
            end
        end
    end)

    it('returns an array of the correct length with the same content (in place)', function()
        for i = 1, FUZZ_COUNT do
            local testArray = generator.ofLength(i, generateString)
            local original = table.clone(testArray)

            generator.shuffleInPlace(testArray)

            expect(#testArray).toEqual(i)

            for _, item in original do
                local index = table.find(testArray, item)
                expect(index).toBeDefined()
                table.remove(testArray, index)
            end
        end
    end)
end)

describe('pickOne', function()
    it('returns nil if the array is empty', function()
        expect(generator.pickOne({})).toBeUndefined()
    end)

    it('returns the only item of the array', function()
        for _ = 1, FUZZ_COUNT do
            local testArray = generator.ofLength(1, generateString)

            expect(generator.pickOne(testArray)).toEqual(testArray[1])
        end
    end)

    it('returns an item from the array', function()
        for i = 2, FUZZ_COUNT do
            local testArray = generator.ofLength(i, generateString)

            local element = generator.pickOne(testArray) :: string

            expect(element).toEqual(expect.any('string'))

            local index = table.find(testArray, element)
            expect(index).toBeDefined()
        end
    end)
end)

describe('pickMultiple', function()
    it('returns an empty array if the array is empty', function()
        expect(generator.pickMultiple({}, 2)).toEqual({})
    end)

    it('returns an empty array if count is 0', function()
        expect(generator.pickMultiple({ 1, 2, 3 }, 0)).toEqual({})
    end)

    it('returns an empty array if count is negative', function()
        expect(generator.pickMultiple({ 1, 2, 3 }, -2)).toEqual({})
    end)

    it('returns the only item of the array', function()
        for i = 1, FUZZ_COUNT do
            local testArray = generator.ofLength(1, generateString)

            expect(generator.pickMultiple(testArray, i)).toEqual(table.create(i, testArray[1]))
        end
    end)

    it('returns multiple items from the array', function()
        for i = 2, FUZZ_COUNT do
            for j = 1, 5 do
                local testArray = generator.ofLength(i, generateString)

                local elements = generator.pickMultiple(testArray, j)

                expect(#elements).toEqual(j)

                for _, element in elements do
                    local index = table.find(testArray, element)
                    expect(index).toBeDefined()
                end
            end
        end
    end)
end)

describe('pickMultipleOnce', function()
    it('returns an empty array if the array is empty', function()
        expect(generator.pickMultipleOnce({}, 2)).toEqual({})
    end)

    it('returns an empty array if count is 0', function()
        expect(generator.pickMultipleOnce({ 1, 2, 3 }, 0)).toEqual({})
    end)

    it('returns an empty array if count is negative', function()
        expect(generator.pickMultipleOnce({ 1, 2, 3 }, -2)).toEqual({})
    end)

    it('returns the only item of the array', function()
        for i = 1, FUZZ_COUNT do
            local testArray = generator.ofLength(1, generateString)

            expect(generator.pickMultipleOnce(testArray, i)).toEqual({ testArray[1] })
        end
    end)

    it('returns multiple items from the array', function()
        for i = 2, FUZZ_COUNT do
            for j = 1, 5 do
                local number = 0
                local testArray = generator.ofLength(i, function()
                    number += 1
                    return number
                end)

                local elements = generator.pickMultipleOnce(testArray, j)

                expect(#elements).toEqual(math.min(i, j))

                local found = {}
                for _, element in elements do
                    local index = table.find(testArray, element)
                    expect(index).toBeDefined()
                    assert(found[element] == nil, `element {element} should not exist`)
                    found[element] = true
                end
            end
        end
    end)
end)
