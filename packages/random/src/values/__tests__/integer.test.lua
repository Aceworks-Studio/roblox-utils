local JestGlobals = require('@pkg/@jsdotlua/jest-globals')
local Math = require('@pkg/@aceworks-studio/math')

local createInteger = require('../integer')

local expect = JestGlobals.expect
local it = JestGlobals.it
local each: <T>({ T }) -> (string, (T) -> ()) -> () = it.each :: any
local beforeAll = JestGlobals.beforeAll

local FUZZ_COUNT = 20

local generator

beforeAll(function()
    generator = createInteger(Random.new())
end)

each({
    { -15, 10 },
    { 15, -10 },
    { -5, 5 },
    { 0, 1 },
    { 10, 0 },
})(
    'returns an integer between %p and %p',
    function(minValue: number, maxValue: number)
        for _ = 1, FUZZ_COUNT do
            local value = generator.between(minValue, maxValue)

            if maxValue < minValue then
                maxValue, minValue = minValue, maxValue
            end

            expect(value).toBeGreaterThanOrEqual(minValue)
            expect(value).toBeLessThanOrEqual(maxValue)
            expect(Math.isInteger(value)).toEqual(true)
        end
    end :: any
)

each({ -15, 15, -5, 0, 10 })(
    'returns an integer above %p',
    function(minValue: number)
        for _ = 1, FUZZ_COUNT do
            local value = generator.above(minValue)
            expect(value).toBeGreaterThan(minValue)
            expect(Math.isSafeInteger(value)).toEqual(true)
        end
    end :: any
)

each({ -15, 15, -5, 0, 10 })(
    'returns an integer above or equal to %p',
    function(minValue: number)
        for _ = 1, FUZZ_COUNT do
            local value = generator.aboveOrEqual(minValue)
            expect(value).toBeGreaterThanOrEqual(minValue)
            expect(Math.isSafeInteger(value)).toEqual(true)
        end
    end :: any
)

each({ -15, 15, -5, 0, 10 })(
    'returns an integer below %p',
    function(maxValue: number)
        for _ = 1, FUZZ_COUNT do
            local value = generator.below(maxValue)
            expect(value).toBeLessThan(maxValue)
            expect(Math.isSafeInteger(value)).toEqual(true)
        end
    end :: any
)

each({ -15, 15, -5, 0, 10 })(
    'returns an integer below or equal to %p',
    function(maxValue: number)
        for _ = 1, FUZZ_COUNT do
            local value = generator.belowOrEqual(maxValue)
            expect(value).toBeLessThanOrEqual(maxValue)
            expect(Math.isSafeInteger(value)).toEqual(true)
        end
    end :: any
)
