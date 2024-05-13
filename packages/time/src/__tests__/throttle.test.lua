local throttle = require('../throttle')

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
    local throttled = throttle(1, fn)
    throttled()
    throttled()
    expect(fnMock).toHaveBeenCalledTimes(1)
end)

it('calls the function again after the duration has passed', function()
    local throttled = throttle(0, fn)
    throttled()
    task.wait()
    throttled()
    expect(fnMock).toHaveBeenCalledTimes(2)
end)

it('schedules the function again for after the duration', function()
    local throttled = throttle(0, fn)
    throttled()
    throttled()
    task.wait()
    expect(fnMock).toHaveBeenCalledTimes(2)
end)
