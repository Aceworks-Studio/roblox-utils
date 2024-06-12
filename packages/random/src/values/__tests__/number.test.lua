local JestGlobals = require('@pkg/@jsdotlua/jest-globals')

local createNumber = require('../number')

local expect = JestGlobals.expect
local it = JestGlobals.it
local each: <T>({ T }) -> (string, (T) -> ()) -> () = it.each :: any
local beforeAll = JestGlobals.beforeAll

local FUZZ_COUNT = 20

local generator

beforeAll(function()
    generator = createNumber(Random.new())
end)

each({
    { -15, 10 },
    { 15, -10 },
    { -5, 5 },
    { 0, 1 },
    { 10, 0 },
})(
    'returns a number between %p and %p',
    function(minValue: number, maxValue: number)
        for i = 1, FUZZ_COUNT do
            local value = generator.between(minValue, maxValue)

            if maxValue < minValue then
                maxValue, minValue = minValue, maxValue
            end

            expect(value).toBeGreaterThanOrEqual(minValue)
            expect(value).toBeLessThanOrEqual(maxValue)
        end
    end :: any
)

each({
    { -10, 10, 20, 0 },
    { 0, 2, 2, 1 },
})(
    'returns a number between %p and %p when generating with span of %p from %p',
    function(minValue: number, maxValue: number, span: number, value: number)
        for i = 1, FUZZ_COUNT do
            local result = generator.spread(value, span)

            expect(result).toBeGreaterThanOrEqual(minValue)
            expect(result).toBeLessThanOrEqual(maxValue)
        end
    end :: any
)

it('returns a number between when generating with span', function()
    for i = 1, FUZZ_COUNT do
        local value = generator.sign()
        expect(value == 1 or value == -1).toEqual(true)
    end
end)

it('returns 1 or -1 when generating with sign', function()
    for i = 1, FUZZ_COUNT do
        local value = generator.sign()
        expect(value == 1 or value == -1).toEqual(true)
    end
end)

it('returns 1 or -1 when generating with sign with a chance', function()
    for i = 1, FUZZ_COUNT do
        local value = generator.sign(0.75)
        expect(value == 1 or value == -1).toEqual(true)
    end
end)
