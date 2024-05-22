local function trim(value: string): string
    return (string.gsub(string.gsub(value, '[%s]+$', ''), '^[%s]+', ''))
end

return trim
