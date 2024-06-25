local Math = require('@pkg/@aceworks-studio/math')

export type IntegerGenerator = {
    above: (value: number) -> number,
    aboveOrEqual: (value: number) -> number,
    below: (value: number) -> number,
    belowOrEqual: (value: number) -> number,
    between: (minValue: number, maxValue: number) -> number,
}

local MAX_INTEGER = Math.maxInteger
local MIN_INTEGER = Math.minInteger

local function createIntegerGenerator(random: Random): IntegerGenerator
    local function above(value: number): number
        return random:NextInteger(value + 1, MAX_INTEGER)
    end

    local function aboveOrEqual(value: number): number
        return random:NextInteger(value, MAX_INTEGER)
    end

    local function below(value: number): number
        return random:NextInteger(MIN_INTEGER, value - 1)
    end

    local function belowOrEqual(value: number): number
        return random:NextInteger(MIN_INTEGER, value)
    end

    local function between(minValue: number, maxValue: number): number
        if maxValue < minValue then
            maxValue, minValue = minValue, maxValue
        end
        return random:NextInteger(minValue, maxValue)
    end

    return {
        above = above,
        aboveOrEqual = aboveOrEqual,
        below = below,
        belowOrEqual = belowOrEqual,
        between = between,
    }
end

return createIntegerGenerator
