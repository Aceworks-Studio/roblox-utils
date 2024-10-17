local function contains(stringValue: string, substring: string): boolean
    return substring == '' or string.find(stringValue, substring, nil, true) ~= nil
end

return contains
