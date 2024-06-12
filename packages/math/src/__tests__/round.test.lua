local JestGlobals = require('@pkg/@jsdotlua/jest-globals')

local round = require('../round')

local expect = JestGlobals.expect
local it = JestGlobals.it
local each: <T>({ T }) -> (string, (T) -> ()) -> () = it.each :: any

local cases = {
    { 0.1, 0 },
    { -1.1, -1 },
    { 0.9, 1 },
    { -0.9, -1 },
}

each(cases)(
    'rounds %p to %p',
    function(value: number, expected: number)
        expect(round(value)).toEqual(expected)
    end :: any
)

local oneDecimalCases = {
    { 0.11, 0.1 },
    { -0.11, -0.1 },
    { 0.93, 0.9 },
    { -1.98, -2 },
}

each(oneDecimalCases)(
    'rounds %p to %p (with one decimal)',
    function(value: number, expected: number)
        expect(round(value, 1)).toEqual(expected)
    end :: any
)

local twoDecimalsCaseses = {
    { 0.111, 0.11 },
    { -0.111, -0.11 },
    { 0.931, 0.93 },
    { -1.9851, -1.99 },
}

each(twoDecimalsCaseses)(
    'rounds %p to %p (with two decimals)',
    function(value: number, expected: number)
        expect(round(value, 2)).toEqual(expected)
    end :: any
)

local identityCases = { 0, -1, 1, 100, -100, math.huge, -math.huge }

each(identityCases)('rounds %p to the same value', function(value)
    expect(round(value)).toEqual(value)
end)
