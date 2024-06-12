local maxInteger = 9007199254740991
local minInteger = -9007199254740991

local function isSafeInteger(value: number): boolean
    return value <= maxInteger and value >= minInteger and value == math.floor(value)
end

return {
    maxInteger = maxInteger,
    minInteger = minInteger,
    isSafeInteger = isSafeInteger,
}
