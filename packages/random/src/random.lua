local createArray = require('./array')
local createValues = require('./values')
local createWeighted = require('./weighted')

export type ArrayGenerator = createArray.ArrayGenerator
export type ValuesGenerator = createValues.ValuesGenerator
export type WeightedChoiceGenerator<T> = createWeighted.WeightedChoiceGenerator<T>
export type WeightedGenerator = createWeighted.WeightedGenerator

export type RandomGenerator = {
    values: ValuesGenerator,
    array: ArrayGenerator,
    weighted: WeightedGenerator,
}

local function createRandom(random: Random): RandomGenerator
    local weightedGenerator = createWeighted(random)

    return {
        values = createValues(random),
        array = createArray(random),
        weighted = weightedGenerator,
    }
end

return createRandom
