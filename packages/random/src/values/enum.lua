export type EnumGenerator = (enum: Enum) -> EnumItem

local function createEnumGenerator(random: Random): EnumGenerator
    local function pickRandomEnum(enum: Enum): EnumItem
        local items = enum:GetEnumItems()
        local length = #items

        if _G.DEV and length == 0 then
            error(`unable to pick random enum item from '{enum}'`)
        end

        return items[random:NextInteger(1, length)]
    end

    return pickRandomEnum
end

return createEnumGenerator
