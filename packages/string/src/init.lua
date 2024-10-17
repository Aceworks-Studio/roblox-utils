local contains = require('./contains')
local endsWith = require('./endsWith')
local startsWith = require('./startsWith')
local trim = require('./trim')
local trimEnd = require('./trimEnd')
local trimStart = require('./trimStart')

return {
    contains = contains,
    endsWith = endsWith,
    startsWith = startsWith,
    trim = trim,
    trimEnd = trimEnd,
    trimStart = trimStart,
}
