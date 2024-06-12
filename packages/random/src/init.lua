local createRandom = require('./random')

export type RandomGenerator = createRandom.RandomGenerator
export type ValuesGenerator = createRandom.ValuesGenerator

local module: RandomGenerator & { create: (Random) -> RandomGenerator } =
    createRandom(Random.new()) :: any

module.create = createRandom

return module
