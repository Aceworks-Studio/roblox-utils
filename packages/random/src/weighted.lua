export type WeightedChoiceGenerator<T> = {
    pickOne: () -> T?,
    pickMultiple: (count: number) -> { T },
    pickMultipleOnce: (count: number) -> { T },
}

export type WeightedGenerator = {
    array: <T>(elements: { T }, weights: { number }) -> WeightedChoiceGenerator<T>,
    map: <T>(map: { [T]: number }) -> WeightedChoiceGenerator<T>,
}

local function returnNil()
    return nil
end

local function returnEmpty()
    return {}
end

local function createWeightedChoiceGenerator(random: Random): WeightedGenerator
    local function createWeightedChoice<T>(
        elements: { T },
        thresholds: { number },
        maxThreshold: number
    ): WeightedChoiceGenerator<T>
        local length = #elements

        if length == 0 then
            return {
                pickOne = returnNil,
                pickMultiple = returnEmpty,
                pickMultipleOnce = returnEmpty,
            }
        elseif length == 1 then
            local element = elements[1]

            local function pickOne(): T?
                return element
            end

            local function pickMultiple(count: number): { T }
                if count <= 0 then
                    return {}
                end
                return table.create(count, element)
            end

            local function pickMultipleOnce(count: number): { T }
                if count <= 0 then
                    return {}
                end
                return { element }
            end

            return {
                pickOne = pickOne,
                pickMultiple = pickMultiple,
                pickMultipleOnce = pickMultipleOnce,
            }
        else
            local function shuffle<A>(array: { A }): { A }
                local new = table.clone(array)

                random:Shuffle(new)

                return new
            end

            local function pickOne(): T?
                local value = maxThreshold * random:NextNumber()

                for i, threshold in thresholds do
                    if value <= threshold then
                        return elements[i]
                    end
                end

                return elements[length]
            end

            local function pickMultiple(count: number): { T }
                if count <= 0 then
                    return {}
                end

                local result = table.create(count)

                for i = 1, count do
                    result[i] = pickOne() :: T
                end

                return result
            end

            local function pickMultipleOnce(count: number): { T }
                if count <= 0 then
                    return {}
                end

                if count >= length then
                    return shuffle(elements)
                end

                local toRemove = length - count

                local removeIndexes = table.create(toRemove)

                local newThresholds = table.clone(thresholds)
                local newMaxThreshold = maxThreshold
                local lastThreshold = #newThresholds

                for _ = 1, toRemove do
                    local value = newMaxThreshold * random:NextNumber()

                    local found = nil

                    for i, threshold in newThresholds do
                        if value <= threshold then
                            found = i
                            break
                        end
                    end

                    if found == nil then
                        found = lastThreshold
                    end

                    local threshold = thresholds[found]
                    local weight = threshold - (if found == 1 then 0 else newThresholds[found - 1])
                    newMaxThreshold -= weight
                    table.remove(newThresholds, found)
                    lastThreshold -= 1

                    -- store the index as a negative number to sort them from the biggest to
                    -- the smallest more quickly
                    table.insert(removeIndexes, -found)
                end

                table.sort(removeIndexes)

                local result = table.clone(elements)

                for _, minusIndex in removeIndexes do
                    table.remove(result, -minusIndex)
                end

                random:Shuffle(result)

                return result
            end

            return {
                pickOne = pickOne,
                pickMultiple = pickMultiple,
                pickMultipleOnce = pickMultipleOnce,
            }
        end
    end

    local function weightedArray<T>(elements: { T }, weights: { number }): WeightedChoiceGenerator<T>
        if _G.DEV and #elements ~= #weights then
            error(
                'attempt to create WeightedChoiceGenerator without the same '
                    .. `amount of elements ({#elements}) and weights ({#weights})`
            )
        end
        local sum = 0
        local thresholds = {}

        for _, weight in weights do
            sum += weight
            table.insert(thresholds, sum)
        end

        return createWeightedChoice(elements, thresholds, sum)
    end

    local function weightedMap<T>(map: { [T]: number }): WeightedChoiceGenerator<T>
        local sum = 0
        local elements = {}
        local thresholds = {}

        for key, weight in map do
            table.insert(elements, key)
            sum += weight
            table.insert(thresholds, sum)
        end

        return createWeightedChoice(elements, thresholds, sum)
    end

    return {
        array = weightedArray,
        map = weightedMap,
    }
end

return createWeightedChoiceGenerator
