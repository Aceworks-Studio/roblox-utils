local loopUntil = require('../loopUntil')

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

it('does not run the function if it is cancelled immediately', function()
    fnMock.mockReturnValue(false)
    local cancel = loopUntil(1, fn)
    cancel()
    expect(fnMock).never.toHaveBeenCalled()
end)

it('runs the function once if it returns true the first time', function()
    fnMock.mockReturnValueOnce(true)
    local _cancel = loopUntil(0, fn)
    task.wait()
    expect(fnMock).toHaveBeenCalledTimes(1)
    expect(fnMock).toHaveBeenCalledWith(expect.any('number'))
end)

it('runs the function twice if it returns true the second time', function()
    fnMock.mockReturnValueOnce(false)
    fnMock.mockReturnValueOnce(true)
    local _cancel = loopUntil(0, fn)
    task.wait()
    task.wait()
    expect(fnMock).toHaveBeenCalledTimes(2)
    expect(fnMock).toHaveBeenCalledWith(expect.any('number'))
end)
