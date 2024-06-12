local createArray = require('./array')
local createValues = require('./values')

export type ArrayGenerator = createArray.ArrayGenerator
export type ValuesGenerator = createValues.ValuesGenerator

export type RandomGenerator = {
    values: ValuesGenerator,
    array: ArrayGenerator,
}

local function createRandom(random: Random): RandomGenerator
    return {
        values = createValues(random),
        array = createArray(random),
    }
end

return createRandom
