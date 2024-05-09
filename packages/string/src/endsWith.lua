local function endsWith(value: string, substring: string): boolean
    local substringLength = string.len(substring)

    if substringLength == 0 then
        return true
    end

    local length = string.len(value)

    if length < substringLength then
        return false
    end

    return string.sub(value, -substringLength) == substring
end

return endsWith
