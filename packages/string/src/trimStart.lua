local function trimStart(value: string): string
    return (string.gsub(value, '^[%s]+', ''))
end

return trimStart
