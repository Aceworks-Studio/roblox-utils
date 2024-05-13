local noYield = require('../noYield')

local jestGlobals = require('@pkg/@jsdotlua/jest-globals')

local expect = jestGlobals.expect
local jest = jestGlobals.jest
local it = jestGlobals.it
local describe = jestGlobals.describe

it('calls functions normally', function()
    local testFnMock, testFn = jest.fn(function()
        return 'success'
    end)

    local result = noYield(testFn, 5, false, 6)

    expect(testFnMock).toHaveBeenCalledTimes(1)
    expect(testFnMock).toHaveBeenCalledWith(5, false, 6)
    expect(result).toBe('success')
end)

if _G.DEV then
    describe('with DEV=true', function()
        it('throws on yield', function()
            local _testFnMock, testFn = jest.fn(function(d)
                task.wait(d)
            end)

            expect(function()
                noYield(testFn, 0.1)
            end).toThrow('function is not allowed to yield')
        end)

        it('propagates error messages', function()
            local _testFnMock, testFn = jest.fn(function()
                error('oof')
            end)

            expect(function()
                noYield(testFn, 0.1)
            end).toThrow('oof')
        end)
    end)
else
    describe('with DEV=false', function()
        it('does not throw on yield', function()
            local _testFnMock, testFn = jest.fn(function(d)
                task.wait(d)
            end)

            expect(function()
                noYield(testFn, 0.1)
            end).never.toThrow('function is not allowed to yield')
        end)
    end)
end
