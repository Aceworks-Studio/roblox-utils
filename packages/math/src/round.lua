local function round(value: number, decimals: number?): number
    if decimals == nil or decimals <= 0 then
        return math.round(value)
    else
        local factor = 10 ^ decimals
        return math.round(value * factor) / factor
    end
end

return round
