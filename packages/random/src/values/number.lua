local Math = require('@pkg/@aceworks-studio/math')

local createIntegerGenerator = require('./integer')

export type IntegerGenerator = createIntegerGenerator.IntegerGenerator

export type NumberGenerator = {
    between: (minValue: number, maxValue: number, decimals: number?) -> number,
    spread: (value: number, span: number) -> number,
    sign: (positiveChance: number?) -> number,
    integer: IntegerGenerator,
}

local function createNumberGenerator(random: Random): NumberGenerator
    local function between(minValue: number, maxValue: number, decimals: number?): number
        if maxValue < minValue then
            maxValue, minValue = minValue, maxValue
        end

        local alpha = random:NextNumber()
        local value = minValue + alpha * (maxValue - minValue)

        if decimals ~= nil and decimals > 0 then
            return Math.round(value, decimals)
        else
            return value
        end
    end

    local function spread(value: number, span: number): number
        return value + span * (random:NextNumber() - 0.5)
    end

    local function sign(positiveChance: number?): number
        return if random:NextNumber() <= (positiveChance or 0.5) then 1 else -1
    end

    return {
        between = between,
        spread = spread,
        sign = sign,
        integer = createIntegerGenerator(random),
    }
end

return createNumberGenerator
