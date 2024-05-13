local yieldUntil = require('../yieldUntil')

local jestGlobals = require('@pkg/@jsdotlua/jest-globals')

local expect = jestGlobals.expect
local jest = jestGlobals.jest
local it = jestGlobals.it
local beforeEach = jestGlobals.beforeEach

local fn
local fnMock

beforeEach(function()
    fnMock, fn = jest.fn()
    fnMock.mockReturnValue(false)
end)

it('runs the function once', function()
    yieldUntil(1 / 60, fn)
    expect(fnMock).toHaveBeenCalledTimes(1)
end)

it('runs the function twice', function()
    fnMock.mockReturnValueOnce(true)
    yieldUntil(1 / 60, fn)
    expect(fnMock).toHaveBeenCalledTimes(2)
end)

it('runs the function until the duration has passed', function()
    fnMock.mockReturnValue(true)
    yieldUntil({ interval = 1 / 60, duration = 0.5 }, fn)
    expect(fnMock).toHaveBeenCalled()
end)
