export type BooleanGenerator = (chance: number?) -> boolean

local function createBooleanGenerator(random: Random): BooleanGenerator
    local function randomBool(chance: number?): boolean
        return random:NextNumber() <= (chance or 0.5)
    end

    return randomBool
end

return createBooleanGenerator
