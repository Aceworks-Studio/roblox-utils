local function trim(value: string): string
    return (string.gsub(value:gsub('[%s]+$', ''), '^[%s]+', ''))
end

return trim
