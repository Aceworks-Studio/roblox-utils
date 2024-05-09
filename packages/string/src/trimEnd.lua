local function trimEnd(value: string): string
    return (string.gsub(value, '[%s]+$', ''))
end

return trimEnd
