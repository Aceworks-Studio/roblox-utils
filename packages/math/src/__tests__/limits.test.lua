local JestGlobals = require('@pkg/@jsdotlua/jest-globals')

local limits = require('../limits')

local expect = JestGlobals.expect
local it = JestGlobals.it
local each: <T>({ T }) -> (string, (T) -> ()) -> () = it.each :: any
local describe = JestGlobals.describe

describe('maximum integer', function()
    it('is not equal to the next bigger integer', function()
        expect(limits.maxInteger).never.toEqual(limits.maxInteger + 1)
    end)

    it('is the biggest integer possible', function()
        local nextInteger = limits.maxInteger + 1
        expect(nextInteger).toEqual(nextInteger + 1)
    end)
end)

describe('minimum integer', function()
    it('is not equal to the next smaller integer', function()
        expect(limits.minInteger).never.toEqual(limits.minInteger - 1)
    end)

    it('is the smallest integer possible', function()
        local nextInteger = limits.minInteger - 1
        expect(nextInteger).toEqual(nextInteger - 1)
    end)
end)

describe('isSafeInteger', function()
    local isSafeInteger = limits.isSafeInteger

    local trueCases = {
        0,
        1,
        -1,
        -100,
        limits.minInteger,
        limits.maxInteger,
    }

    each(trueCases)('returns true for %p', function(value)
        expect(isSafeInteger(value)).toEqual(true)
    end)

    local falseCases = {
        math.huge,
        0 / 0,
        limits.maxInteger + 1,
        limits.minInteger - 1,
        2.5,
    }

    each(falseCases)('returns true for %p', function(value)
        expect(isSafeInteger(value)).toEqual(false)
    end)
end)
