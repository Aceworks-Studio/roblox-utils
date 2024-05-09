local debounce = require('../debounce')

local jestGlobals = require('@pkg/@jsdotlua/jest-globals')

local expect = jestGlobals.expect
local jest = jestGlobals.jest
local it = jestGlobals.it
local beforeEach = jestGlobals.beforeEach

local fn
local fnMock

beforeEach(function()
    fnMock, fn = jest.fn()
end)

it('calls the function once within a frame', function()
    local debounced = debounce(1, fn)
    debounced()
    debounced()
    expect(fnMock).toHaveBeenCalledTimes(1)
end)

it('calls the function again after the duration has passed', function()
    local debounced = debounce(0, fn)
    debounced()
    task.wait()
    debounced()
    expect(fnMock).toHaveBeenCalledTimes(2)
end)
