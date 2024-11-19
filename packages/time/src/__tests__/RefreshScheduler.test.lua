local jestGlobals = require('@pkg/@jsdotlua/jest-globals')

local expect = jestGlobals.expect
local it = jestGlobals.it
local describe = jestGlobals.describe
local beforeEach = jestGlobals.beforeEach
local jest = jestGlobals.jest

local RefreshScheduler = require('../RefreshScheduler')

describe('deferred tonumber scheduler', function()
    local clockMock
    local workFn
    local scheduler
    local onError

    beforeEach(function()
        clockMock = jest.fn()
        workFn = jest.fn(tonumber)
        onError = jest.fn(function(request, err)
            error(`uncaught error while working on request '{request}': {err}`)
        end)
        scheduler = RefreshScheduler.new(function(value: string)
            return workFn(value)
        end, {
            rateLimitBudget = 10,
            clock = clockMock,
            onError = onError,
        })
    end)

    it('never submitted work has no result', function()
        expect(scheduler:getResult('12')).toEqual(nil)
    end)

    it('submitted work is not immediately scheduled', function()
        local request = '12'
        scheduler:submit(request)
        expect(scheduler:getResult(request)).toEqual(nil)
    end)

    it('submitted work is scheduled when there is budget after a tick', function()
        local request = '12'
        scheduler:submit(request)
        clockMock.mockReturnValue(1)

        scheduler:tick()
        task.wait()

        expect(scheduler:getResult(request)).toEqual(12)
    end)

    it('submitted work can be cancelled before execution', function()
        local request = '12'
        scheduler:submit(request)
        clockMock.mockReturnValue(1)

        scheduler:tick()
        scheduler:remove(request)
        task.wait()

        expect(scheduler:getResult(request)).toEqual(nil)
    end)

    it('submitted work can be cancelled after execution', function()
        local request = '12'
        scheduler:submit(request)
        clockMock.mockReturnValue(1)

        scheduler:tick()
        task.wait()

        expect(scheduler:getResult(request)).toEqual(12)
        scheduler:remove(request)
        expect(scheduler:getResult(request)).toEqual(nil)
    end)

    it('submitted work is refreshed after its refresh interval', function()
        local request = '12'
        local refreshInterval = 20
        scheduler:submit(request, refreshInterval)
        clockMock.mockReturnValue(1)

        scheduler:tick()
        task.wait()

        expect(workFn).toHaveBeenCalledTimes(1)
        expect(scheduler:getResult(request)).toEqual(12)

        local refreshedResult = 500
        workFn.mockReturnValue(refreshedResult)
        clockMock.mockReturnValue(refreshInterval + 1)

        scheduler:tick()
        task.wait()

        expect(workFn).toHaveBeenCalledTimes(2)
        expect(scheduler:getResult(request)).toEqual(refreshedResult)
    end)

    it('enforces the concurrency budget', function()
        local request1 = '50'
        local request2 = '60'
        scheduler:submit(request1)
        scheduler:submit(request2)

        clockMock.mockReturnValue(1)
        scheduler:tick()
        task.wait()

        expect(scheduler:getResult(request1)).toEqual(50)
        expect(scheduler:getResult(request2)).toEqual(nil)

        clockMock.mockReturnValue(2)
        scheduler:tick()
        task.wait()

        expect(scheduler:getResult(request2)).toEqual(60)
    end)

    describe('with concurrency', function()
        beforeEach(function()
            scheduler = RefreshScheduler.new(function(value: string)
                return workFn(value)
            end, {
                concurrencyBudget = 2,
                rateLimitBudget = 2,
                clock = clockMock,
                onError = function(err, request)
                    error(`uncaught error while working on request '{request}': {err}`)
                end,
            })
        end)

        it('handles multiple submissions without interference', function()
            local request1 = '10'
            local request2 = '20'
            scheduler:submit(request1)
            scheduler:submit(request2)
            clockMock.mockReturnValue(1)

            scheduler:tick()
            task.wait()

            expect(scheduler:getResult(request1)).toEqual(10)
            expect(scheduler:getResult(request2)).toEqual(20)
        end)
    end)

    describe('tiny rate limit budget', function()
        local rateLimitInterval = 15

        beforeEach(function()
            scheduler = RefreshScheduler.new(function(value: string)
                return workFn(value)
            end, {
                concurrencyBudget = 1,
                rateLimitBudget = 2,
                rateLimitInterval = rateLimitInterval,
                clock = clockMock,
                onError = function(err, request)
                    error(`uncaught error while working on request '{request}': {err}`)
                end,
            })
        end)

        it('respects rate limit and concurrency budget across multiple ticks', function()
            local request1 = '30'
            local request2 = '35'
            local request3 = '40'
            scheduler:submit(request1)
            scheduler:submit(request2)
            scheduler:submit(request3)

            clockMock.mockReturnValue(1)
            scheduler:tick()
            task.wait()

            expect(scheduler:getResult(request1)).toEqual(30)

            clockMock.mockReturnValue(2)
            scheduler:tick()
            task.wait()

            expect(scheduler:getResult(request1)).toEqual(30)
            expect(scheduler:getResult(request2)).toEqual(35)
            expect(scheduler:getResult(request3)).toEqual(nil)

            clockMock.mockReturnValue(rateLimitInterval - 1)
            scheduler:tick()
            task.wait()

            expect(scheduler:getResult(request1)).toEqual(30)
            expect(scheduler:getResult(request2)).toEqual(35)
            expect(scheduler:getResult(request3)).toEqual(nil)

            clockMock.mockReturnValue(rateLimitInterval + 10)
            scheduler:tick()
            task.wait()

            expect(scheduler:getResult(request1)).toEqual(30)
            expect(scheduler:getResult(request2)).toEqual(35)
            expect(scheduler:getResult(request3)).toEqual(40)
        end)
    end)

    it('handles errors in worker function gracefully', function()
        local request = 'error-case'
        local errorObject = { message = 'simulated error' }
        -- mock return value to avoid throwing the error in the output
        onError.mockReturnValue(nil)
        workFn.mockImplementation(function()
            error(errorObject)
        end)
        scheduler:submit(request)
        clockMock.mockReturnValue(1)

        scheduler:tick()
        task.wait()

        expect(scheduler:getResult(request)).toEqual(nil)
        expect(onError).toHaveBeenCalledWith(errorObject, request)
    end)

    it('invokes onChange callback when result changes', function()
        local request = '70'
        local callback, callbackFn = jest.fn()
        scheduler:onChange(callbackFn)

        scheduler:submit(request)
        clockMock.mockReturnValue(1)
        scheduler:tick()
        task.wait()

        expect(callback).toHaveBeenCalledWith(request, 70)
    end)

    it('does not invoke onChange if result is unchanged', function()
        local request = '80'
        local callback, callbackFn = jest.fn()
        scheduler:onChange(callbackFn)
        local refreshInterval = 100
        scheduler:submit(request, refreshInterval)

        clockMock.mockReturnValue(1)
        scheduler:tick()
        task.wait()

        clockMock.mockReturnValue(refreshInterval + 10)
        scheduler:tick()
        task.wait()

        expect(workFn).toHaveBeenCalledTimes(2)
        expect(callback).toHaveBeenCalledTimes(1)
    end)
end)
