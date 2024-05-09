local infinity = math.huge
local negativeInfinity = -math.huge

local function isInteger(value: number): boolean
    return value == math.floor(value) and value ~= infinity and value ~= negativeInfinity
end

return isInteger
