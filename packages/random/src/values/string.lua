local createArrayGenerator = require('../array')

export type CharacterSetGenerator = string | (() -> string)?

export type StringGenerator = {
    ofLength: (length: number, characterGenerator: CharacterSetGenerator) -> string,
    between: (
        minLength: number,
        maxLength: number,
        characterGenerator: CharacterSetGenerator
    ) -> string,
    substring: (value: string, length: number?) -> string,
}

local function createStringGenerator(random: Random): StringGenerator
    local arrayGenerator = createArrayGenerator(random)

    local function defaultCharacterGenerator(): string
        local byte = random:NextInteger(1, 128)
        return string.char(byte)
    end

    local function getCharacterFn(characterGenerator: CharacterSetGenerator)
        if characterGenerator == nil then
            return defaultCharacterGenerator
        elseif type(characterGenerator) == 'string' then
            local length = #characterGenerator

            if _G.DEV and length == 0 then
                error('attempt to use an empty character set to generate a random string')
            end

            local function generateCharacter(): string
                local index = random:NextInteger(1, length)
                return string.sub(characterGenerator, index, index)
            end

            return generateCharacter
        else
            return characterGenerator
        end
    end

    local function ofLength(length: number, characterGenerator: CharacterSetGenerator): string
        if length == 0 then
            return ''
        elseif length == 1 then
            return getCharacterFn(characterGenerator)()
        else
            return table.concat(arrayGenerator.ofLength(length, getCharacterFn(characterGenerator)))
        end
    end

    local function between(
        minLength: number,
        maxLength: number,
        characterGenerator: CharacterSetGenerator
    ): string
        if maxLength < minLength then
            maxLength, minLength = minLength, maxLength
        end
        local length = random:NextNumber(minLength, maxLength)

        return ofLength(length, characterGenerator)
    end

    local function substring(value: string, length: number?): string
        local valueLength = #value

        if valueLength == 0 then
            return ''
        end

        local substringLength = if length == nil
            then random:NextInteger(1, valueLength)
            else math.min(length, valueLength)

        local difference = valueLength - substringLength

        if difference == 0 then
            return value
        end

        local shift = random:NextInteger(1, difference + 1)

        return string.sub(value, shift, shift + substringLength - 1)
    end

    return {
        ofLength = ofLength,
        between = between,
        substring = substring,
    }
end

return createStringGenerator
