export type CharacterGenerator = {
    pick: (characters: string) -> string,
    letter: () -> string,
    alphaNumeric: () -> string,
    upperCaseLetter: () -> string,
    lowerCaseLetter: () -> string,
    digit: () -> string,
    hexDigit: () -> string,
}

local function createCharacterGenerator(random: Random): CharacterGenerator
    local function pick(characters: string): string
        local index = random:NextInteger(1, #characters)
        return string.sub(characters, index, index)
    end

    local function letter(): string
        local byte = random:NextInteger(65, 90 + 26)
        return string.char(if byte > 90 then byte + 6 else byte)
    end

    local function alphaNumeric(): string
        local byte = random:NextInteger(48, 57 + (2 * 26))
        return string.char(
            if byte > 57 then byte + 7 elseif byte > (57 + 26) then byte + 7 + 6 else byte
        )
    end

    local function upperCaseLetter(): string
        return string.char(random:NextInteger(65, 90))
    end

    local function lowerCaseLetter(): string
        return string.char(random:NextInteger(97, 122))
    end

    local function digit(): string
        return string.char(random:NextInteger(48, 57))
    end

    local HEX_DIGITS = '0123456789ABCDEF'

    local function hexDigit(): string
        local index = random:NextInteger(1, 16)
        return string.sub(HEX_DIGITS, index, index)
    end

    return {
        pick = pick,
        letter = letter,
        alphaNumeric = alphaNumeric,
        upperCaseLetter = upperCaseLetter,
        lowerCaseLetter = lowerCaseLetter,
        digit = digit,
        hexDigit = hexDigit,
    }
end

return createCharacterGenerator
