local Disk = require('@pkg/luau-disk')
local Teardown = require('@pkg/luau-teardown')
local task = require('@pkg/luau-task')

type Teardown = Teardown.Teardown

local Array = Disk.Array
local Map = Disk.Map

export type StateController = {
    addCleanup: (...Teardown) -> () -> (),
    next: (nextState: string, nextConfig: any) -> never,
}

export type StateEvent = { state: string, config: any, time: number }
export type StateHistory = { StateEvent }

export type StateMachineConfiguration<T = {}> = {
    defaultState: string,
    defaultStateConfig: any,
    setupController: ((StateController) -> T)?,
    states: {
        [string]: (StateController & T, config: any) -> (),
    },
    onStateChange: (state: string, config: any) -> ()?,
    onStateHistoryChange: (StateHistory) -> ()?,
    getCurrentTime: (() -> number)?,
}

local function create<T>(config: StateMachineConfiguration<T>): () -> ()
    local states = config.states
    local onStateHistoryChange = config.onStateHistoryChange
    local onStateChange = config.onStateChange
    local setupController = config.setupController
    local getCurrentTime: () -> number = config.getCurrentTime or os.clock

    if onStateHistoryChange then
        local currentStateChange = onStateChange
        local history: StateHistory = {}

        local function updateHistory(state: string, config: any)
            history = Array.push(history, {
                state = state,
                config = config,
                time = getCurrentTime(),
            })
            task.spawn(onStateHistoryChange, history)
            if currentStateChange then
                task.spawn(currentStateChange, state, config)
            end
        end
        onStateChange = updateHistory
    end

    local cleanup = {}
    local currentCleanupIndex = 0

    local function addCleanup(...: Teardown): () -> ()
        currentCleanupIndex += 1
        local index = currentCleanupIndex

        local fn = Teardown.fn(...)
        local called = false

        local function doCleanup()
            if called then
                return
            end
            called = true
            fn()
        end

        cleanup[index] = doCleanup

        return doCleanup
    end

    local function runCleanup()
        local currentCleanup = cleanup
        local lastIndex = currentCleanupIndex
        cleanup = {}
        currentCleanupIndex = 0
        for i = 1, lastIndex do
            if currentCleanup[i] then
                currentCleanup[i]()
            end
        end
    end

    local function changeState(state: string, config: any?)
        local stateFn = states[state]
        if not stateFn then
            warn('could not find any state named: ', state)
            return
        end

        local called = false

        local function localChangeState(nextState: string, nextConfig: any?): never
            local currentThread = coroutine.running()

            local shouldChangeState = not called

            if shouldChangeState then
                called = true
            end

            task.defer(function()
                coroutine.close(currentThread)
                if shouldChangeState then
                    runCleanup()
                    changeState(nextState, nextConfig)
                end
            end)

            while true do
                coroutine.yield()
            end
        end

        addCleanup(function()
            called = true
        end)

        if onStateChange then
            task.spawn(onStateChange, state, config)
        end

        local baseController = { addCleanup = addCleanup, next = localChangeState }
        local controller = Map.merge(
            baseController,
            if setupController then setupController(baseController) else nil
        )

        addCleanup(task.spawn(stateFn, controller :: any, config) :: any)
    end

    changeState(config.defaultState, config.defaultStateConfig)

    return runCleanup
end

return create
