export type ArrayGenerator = {
    ofLength: <T>(length: number, generator: () -> T) -> { T },
    between: <T>(minLength: number, maxLength: number, generator: () -> T) -> { T },
    shuffle: <T>(array: { T }) -> { T },
    shuffleInPlace: <T>(array: { T }) -> (),
    pickOne: <T>(array: { T }) -> T?,
    pickMultiple: <T>(array: { T }, count: number) -> { T },
    pickMultipleOnce: <T>(array: { T }, count: number) -> { T },
}

local function createArrayGenerator(random: Random): ArrayGenerator
    local function ofLength<T>(length: number, generator: () -> T): { T }
        local array = table.create(length)

        for i = 1, length do
            array[i] = generator()
        end

        return array
    end

    local function between<T>(minLength: number, maxLength: number, generator: () -> T): { T }
        if maxLength < minLength then
            maxLength, minLength = minLength, maxLength
        end
        local length = random:NextNumber(minLength, maxLength)

        return ofLength(length, generator)
    end

    local function shuffle<T>(array: { T }): { T }
        local new = table.clone(array)

        random:Shuffle(new)

        return new
    end

    local function shuffleInPlace<T>(array: { T })
        random:Shuffle(array)
    end

    local function pickOne<T>(array: { T }): T?
        local length = #array

        if length == 0 then
            return nil
        elseif length == 1 then
            return array[1]
        else
            return array[random:NextInteger(1, length)]
        end
    end

    local function pickMultiple<T>(array: { T }, count: number): { T }
        local length = #array

        if length == 0 or count <= 0 then
            return {}
        elseif length == 1 then
            return table.create(count, array[1])
        end

        local result = table.create(count)

        for i = 1, count do
            result[i] = array[random:NextInteger(1, length)]
        end

        return result
    end

    local function pickMultipleOnce<T>(array: { T }, count: number): { T }
        local length = #array

        if length == 0 or count <= 0 then
            return {}
        elseif length == 1 then
            return { array[1] }
        end

        if count >= length then
            return shuffle(array)
        end

        local result = table.clone(array)
        random:Shuffle(result)
        local toRemove = length - count

        for _ = 1, toRemove do
            table.remove(result)
        end

        return result
    end

    return {
        ofLength = ofLength,
        between = between,
        shuffle = shuffle,
        shuffleInPlace = shuffleInPlace,
        pickOne = pickOne,
        pickMultiple = pickMultiple,
        pickMultipleOnce = pickMultipleOnce,
    }
end

return createArrayGenerator
