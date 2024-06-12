local createBooleanGenerator = require('./boolean')
local createCharacterGenerator = require('./character')
local createColorGenerator = require('./color')
local createEnumGenerator = require('./enum')
local createNumberGenerator = require('./number')
local createStringGenerator = require('./string')

export type BooleanGenerator = createBooleanGenerator.BooleanGenerator
export type CharacterGenerator = createCharacterGenerator.CharacterGenerator
export type ColorGenerator = createColorGenerator.ColorGenerator
export type EnumGenerator = createEnumGenerator.EnumGenerator
export type NumberGenerator = createNumberGenerator.NumberGenerator
export type StringGenerator = createStringGenerator.StringGenerator

export type ValuesGenerator = {
    boolean: BooleanGenerator,
    character: CharacterGenerator,
    color: ColorGenerator,
    enum: EnumGenerator,
    number: NumberGenerator,
    string: StringGenerator,
}

local function createValues(random): ValuesGenerator
    return {
        boolean = createBooleanGenerator(random),
        character = createCharacterGenerator(random),
        color = createColorGenerator(random),
        enum = createEnumGenerator(random),
        number = createNumberGenerator(random),
        string = createStringGenerator(random),
    }
end

return createValues
