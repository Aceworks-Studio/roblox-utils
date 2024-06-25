local JestGlobals = require('@pkg/@jsdotlua/jest-globals')

local createEnumGenerator = require('../enum')

local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeAll = JestGlobals.beforeAll

local generator

beforeAll(function()
    generator = createEnumGenerator(Random.new())
end)

local cases: { [string]: Enum } = {
    FillDirection = Enum.FillDirection,
    FormFactor = Enum.FormFactor,
    AspectType = Enum.AspectType,
    PartType = Enum.PartType,
}

for name, enum in cases do
    it(`returns a {name} enum item`, function()
        local item = generator(enum)
        expect(item:IsA(name)).toEqual(true)
    end)
end
