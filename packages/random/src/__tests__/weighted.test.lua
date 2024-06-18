local JestGlobals = require('@pkg/@jsdotlua/jest-globals')

local createString = require('../values/string')
local createWeighted = require('../weighted')

local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeAll = JestGlobals.beforeAll
local beforeEach = JestGlobals.beforeEach
local describe = JestGlobals.describe

local FUZZ_COUNT = 20

local weighted
local stringGenerator

beforeAll(function()
    weighted = createWeighted(Random.new())
    stringGenerator = createString(Random.new())
end)

local function generateString(): string
    return stringGenerator.ofLength(16)
end

local arraySetup = {
    name = 'array',
    empty = function()
        return weighted.array({}, {})
    end,
    generatorSingle = function(value)
        return weighted.array(value, { 1 })
    end,
    generator = function(value)
        return weighted.array(value, { 1, 3, 5 })
    end,
}

local function generateDistinctArray(length: number): { string }
    local result = {}
    while #result < length do
        local new = generateString()
        if table.find(result, new) == nil then
            table.insert(result, new)
        end
    end
    return result
end

local mapSetup = {
    name = 'map',
    empty = function()
        return weighted.map({})
    end,
    generatorSingle = function(value)
        local chanceMap = {}
        for index, item in value do
            chanceMap[item] = index
        end
        return weighted.map(chanceMap)
    end,
    generator = function(value)
        local chanceMap = {}
        for index, item in value do
            chanceMap[item] = index
        end
        return weighted.map(chanceMap)
    end,
}

for _, setup in { arraySetup, mapSetup } do
    describe(`from weight {setup.name}`, function()
        local generatorEmpty
        local arraySingle
        local generatorSingle
        local testArray
        local generator

        beforeEach(function()
            generatorEmpty = setup.empty()
            arraySingle = { 'abc' }
            generatorSingle = setup.generatorSingle(arraySingle)
            testArray = generateDistinctArray(4)
            generator = setup.generator(testArray)
        end)

        describe('pickOne', function()
            it('returns nil if the array is empty', function()
                expect(generatorEmpty.pickOne()).toBeUndefined()
            end)

            it('returns the only item of the array', function()
                for _ = 1, FUZZ_COUNT do
                    expect(generatorSingle.pickOne()).toEqual(arraySingle[1])
                end
            end)

            it('returns an item from the array', function()
                for _ = 2, FUZZ_COUNT do
                    local element = generator.pickOne() :: string

                    expect(element).toEqual(expect.any('string'))

                    local index = table.find(testArray, element)
                    expect(index).toBeDefined()
                end
            end)
        end)

        describe('pickMultiple', function()
            it('returns an empty array if the array is empty', function()
                expect(generatorEmpty.pickMultiple(2)).toEqual({})
            end)

            it('returns an empty array if count is 0', function()
                expect(generator.pickMultiple(0)).toEqual({})
            end)

            it('returns an empty array if count is negative', function()
                expect(generator.pickMultiple(-2)).toEqual({})
            end)

            it('returns the only item of the array', function()
                for i = 1, FUZZ_COUNT do
                    expect(generatorSingle.pickMultiple(i)).toEqual(table.create(i, arraySingle[1]))
                end
            end)

            it('returns multiple items from the array', function()
                for _ = 2, FUZZ_COUNT do
                    for j = 1, 5 do
                        local elements = generator.pickMultiple(j)

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
                expect(generatorEmpty.pickMultipleOnce(2)).toEqual({})
            end)

            it('returns an empty array if count is 0', function()
                expect(generator.pickMultipleOnce(0)).toEqual({})
            end)

            it('returns an empty array if count is negative', function()
                expect(generator.pickMultipleOnce(-2)).toEqual({})
            end)

            it('returns the only item of the array', function()
                for i = 1, FUZZ_COUNT do
                    expect(generatorSingle.pickMultipleOnce(i)).toEqual({ arraySingle[1] })
                end
            end)

            it('returns multiple items from the array', function()
                for _ = 2, FUZZ_COUNT do
                    for j = 1, 5 do
                        local elements = generator.pickMultipleOnce(j)

                        expect(#elements).toEqual(math.min(j, #testArray))

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
    end)
end
