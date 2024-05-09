local infinity = math.huge
local negativeInfinity = -math.huge

local function isFinite(value: number): boolean
    return value == value and value ~= infinity and value ~= negativeInfinity
end

return isFinite
