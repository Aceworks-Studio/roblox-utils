local JestGlobals = require('@pkg/@jsdotlua/jest-globals')

local create = require('../create')

local expect = JestGlobals.expect
local jest = JestGlobals.jest
local it = JestGlobals.it

it('runs the state machine immediately without yielding', function()
    local done = false

    create({
        defaultState = 'a',
        defaultStateConfig = 1,
        states = {
            a = function(controller)
                controller.next('b')
            end,
            b = function(controller)
                controller.next('c')
            end,
            c = function(_controller)
                done = true
            end,
        },
    })

    task.wait()
    expect(done).toEqual(true)
end)

it('passes a config to each state', function()
    local done = false
    local checkConfig = jest.fn()

    create({
        defaultState = 'a',
        defaultStateConfig = 1,
        states = {
            a = function(controller, config)
                checkConfig('a', config)
                controller.next('b', 2)
            end,
            b = function(controller, config)
                checkConfig('b', config)
                controller.next('c', 3)
            end,
            c = function(_controller, config)
                checkConfig('c', config)
                done = true
            end,
        },
    })

    task.wait()
    expect(checkConfig.mock.calls).toEqual({
        { 'a' :: string | number, 1 },
        { 'b' :: string | number, 2 },
        { 'c' :: string | number, 3 },
    })
    expect(done).toEqual(true)
end)

it('calls the onStateChange callback with the state and its config', function()
    local done = false
    local onStateChange, onStateChangeFn = jest.fn()

    create({
        defaultState = 'a',
        defaultStateConfig = 1,
        onStateChange = onStateChangeFn,
        states = {
            a = function(controller)
                controller.next('b', 2)
            end,
            b = function(controller)
                controller.next('c', 3)
            end,
            c = function(_controller)
                done = true
            end,
        },
    })

    task.wait()
    expect(onStateChange.mock.calls).toEqual({
        { 'a' :: string | number, 1 },
        { 'b' :: string | number, 2 },
        { 'c' :: string | number, 3 },
    })
    expect(done).toEqual(true)
end)

it('calls the onStateHistoryChange callback with the state history', function()
    local done = false
    local onStateHistoryChange, onStateHistoryChangeFn = jest.fn()

    local i = 0
    local function getCurrentTime()
        i += 1
        return i / 10
    end

    create({
        defaultState = 'a',
        defaultStateConfig = 1,
        controllerFunctions = nil,
        onStateHistoryChange = onStateHistoryChangeFn,
        getCurrentTime = getCurrentTime,
        states = {
            a = function(controller)
                controller.next('b', 2)
            end,
            b = function(controller)
                controller.next('c', 3)
            end,
            c = function(_controller)
                done = true
            end,
        },
    })

    task.wait()
    expect(onStateHistoryChange.mock.calls).toEqual({
        { { { state = 'a', config = 1, time = 0.1 } } },
        { { { state = 'a', config = 1, time = 0.1 }, { state = 'b', config = 2, time = 0.2 } } },
        {
            {
                { state = 'a', config = 1, time = 0.1 },
                { state = 'b', config = 2, time = 0.2 },
                { state = 'c', config = 3, time = 0.3 },
            },
        },
    })
    expect(done).toEqual(true)
end)

it('passes custom functions to the controller', function()
    local done = false

    create({
        defaultState = 'a',
        defaultStateConfig = 1,
        setupController = function(controller)
            return {
                goToC = function(config)
                    controller.next('c', config)
                end,
            }
        end,
        states = {
            a = function(controller)
                controller.goToC(5)
                -- this should not run
                controller.next('b', 2)
            end,
            b = function() end,
            c = function(_controller)
                done = true
            end,
        },
    })

    task.wait()
    expect(done).toEqual(true)
end)
