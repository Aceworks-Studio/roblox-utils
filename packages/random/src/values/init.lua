local createBooleanGenerator = require('./boolean')
local createCharacterGenerator = require('./character')
local createColorGenerator = require('./color')
local createEnumGenerator = require('./enum')
local createNumberGenerator = require('./number')
local createStringGenerator = require('./string')
local createVectorGenerators = require('./vectors')

export type BooleanGenerator = createBooleanGenerator.BooleanGenerator
export type CharacterGenerator = createCharacterGenerator.CharacterGenerator
export type ColorGenerator = createColorGenerator.ColorGenerator
export type EnumGenerator = createEnumGenerator.EnumGenerator
export type NumberGenerator = createNumberGenerator.NumberGenerator
export type StringGenerator = createStringGenerator.StringGenerator
export type CharacterSetGenerator = createStringGenerator.CharacterSetGenerator
export type Vector2Generator = createVectorGenerators.Vector2Generator
export type Vector3Generator = createVectorGenerators.Vector3Generator

export type ValuesGenerator = {
    boolean: BooleanGenerator,
    character: CharacterGenerator,
    color: ColorGenerator,
    enum: EnumGenerator,
    number: NumberGenerator,
    string: StringGenerator,
    vector2: Vector2Generator,
    vector3: Vector3Generator,
}

local function createValues(random): ValuesGenerator
    local vectorGenerators = createVectorGenerators(random)

    return {
        boolean = createBooleanGenerator(random),
        character = createCharacterGenerator(random),
        color = createColorGenerator(random),
        enum = createEnumGenerator(random),
        number = createNumberGenerator(random),
        string = createStringGenerator(random),
        vector2 = vectorGenerators.vector2,
        vector3 = vectorGenerators.vector3,
    }
end

return createValues
