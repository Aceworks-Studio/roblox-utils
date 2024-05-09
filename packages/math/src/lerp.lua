local function lerp(initialValue: number, finalValue: number, alpha: number): number
    return initialValue * (1 - alpha) + alpha * finalValue
end

return lerp
