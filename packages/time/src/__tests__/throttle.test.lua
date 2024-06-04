local throttle = require('../throttle')

local jestGlobals = require('@pkg/@jsdotlua/jest-globals')

local expect = jestGlobals.expect
local jest = jestGlobals.jest
local it = jestGlobals.it
local beforeEach = jestGlobals.beforeEach

local LESS_THAN_FRAME = 1 / 100
local MORE_THAN_FRAME = 1 / 40

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
    local throttled = throttle(LESS_THAN_FRAME, fn)
    throttled()
    task.wait(MORE_THAN_FRAMEg)
    throttled()
    expect(fnMock).toHaveBeenCalledTimes(2)
end)

it('schedules the function again for after the duration', function()
    local throttled = throttle(LESS_THAN_FRAME, fn)
    throttled()
    throttled()
    task.wait(MORE_THAN_FRAME)
    expect(fnMock).toHaveBeenCalledTimes(2)
end)

it('schedules the function again for after the duration only once', function()
    local throttled = throttle(LESS_THAN_FRAME, fn)
    throttled()
    throttled()
    throttled()
    throttled()
    task.wait(MORE_THAN_FRAME)
    expect(fnMock).toHaveBeenCalledTimes(2)
end)
