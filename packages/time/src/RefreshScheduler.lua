local Disk = require('@pkg/luau-disk')
local Math = require('@pkg/@aceworks-studio/math')
local Signal = require('@pkg/luau-signal')
local Teardown = require('@pkg/luau-teardown')

local loopWhile = require('./loopWhile')

type Signal<T...> = Signal.Signal<T...>

local Array = Disk.Array

export type RefreshScheduler<Request, Result> = {
    getResult: (self: RefreshScheduler<Request, Result>, request: Request) -> Result?,
    submit: (
        self: RefreshScheduler<Request, Result>,
        request: Request,
        refreshInterval: number?
    ) -> (),
    remove: (self: RefreshScheduler<Request, Result>, request: Request) -> (),
    tick: (self: RefreshScheduler<Request, Result>) -> (),
    teardown: (self: RefreshScheduler<Request, Result>) -> (),
    onChange: (
        self: RefreshScheduler<Request, Result>,
        callback: (Request, Result) -> ()
    ) -> () -> (),
}

export type RefreshSchedulerOptions<Request> = {
    getKey: ((Request) -> string)?,
    rateLimitBudget: number,
    rateLimitInterval: number?,
    concurrencyBudget: number?,
    refreshInterval: number?,
    clock: (() -> number)?,
    tickInterval: number?,
    onError: (err: any, request: Request) -> ()?,
}

type Private<Request, Result> = {
    _worker: (Request) -> Result,
    _cache: { [string]: { value: Result } },
    _threads: { [string]: thread },
    _newlySubmitted: { [string]: Request },
    _newlySubmittedQueue: {
        {
            key: string,
            request: Request,
            refreshInterval: number?,
        }
    },
    _refreshQueue: {
        {
            key: string,
            request: Request,
            refreshInterval: number,
            timestamp: number,
        }
    },
    _getKey: ((Request) -> string)?,
    _rateLimitBudget: number,
    _incrementRateLimitBudget: { number },
    _concurrencyBudget: number,
    _rateLimitInterval: number,
    _defaultRefreshInterval: number,
    _clock: () -> number,
    _disconnect: () -> ()?,
    _onError: (err: any, request: Request) -> ()?,

    _onChange: Signal<Request, Result>,

    _work: (self: RefreshScheduler<Request, Result>) -> (),
    _consumeBudget: (self: RefreshScheduler<Request, Result>) -> (),
    _insertResult: (
        self: RefreshScheduler<Request, Result>,
        key: string,
        request: Request,
        result: Result
    ) -> (),
    _addToRefreshQueue: (
        self: RefreshScheduler<Request, Result>,
        key: string,
        request: Request,
        refreshInterval: number
    ) -> (),
}

type PrivateRefreshScheduler<Request, Result> =
    RefreshScheduler<Request, Result>
    & Private<Request, Result>

type RefreshSchedulerStatic = {
    new: <Request, Result>(
        worker: (Request) -> Result,
        options: RefreshSchedulerOptions<Request>
    ) -> RefreshScheduler<Request, Result>,

    getResult: <Request, Result>(
        self: RefreshScheduler<Request, Result>,
        request: Request
    ) -> Result?,
    submit: <Request, Result>(
        self: RefreshScheduler<Request, Result>,
        request: Request,
        refreshInterval: number?
    ) -> (),
    remove: <Request, Result>(self: RefreshScheduler<Request, Result>, request: Request) -> (),
    tick: <Request, Result>(self: RefreshScheduler<Request, Result>) -> (),
    teardown: <Request, Result>(self: RefreshScheduler<Request, Result>) -> (),
    onChange: <Request, Result>(
        self: RefreshScheduler<Request, Result>,
        callback: (Request, Result) -> ()
    ) -> () -> (),

    _work: <Request, Result>(self: RefreshScheduler<Request, Result>) -> (),
    _consumeBudget: <Request, Result>(self: RefreshScheduler<Request, Result>) -> (),
    _insertResult: <Request, Result>(
        self: RefreshScheduler<Request, Result>,
        key: string,
        request: Request,
        result: Result
    ) -> (),
    _addToRefreshQueue: <Request, Result>(
        self: RefreshScheduler<Request, Result>,
        key: string,
        request: Request,
        refreshInterval: number
    ) -> (),
}

local function assertRequestKey(key: unknown)
    assert(
        type(key) == 'string',
        'error using the RefreshScheduler: make sure to provide the "getKey" function to the scheduler options'
    )
end

local RefreshScheduler: RefreshSchedulerStatic = {} :: any
local RefreshSchedulerMetatable = {
    __index = RefreshScheduler,
}

function RefreshScheduler.new<Request, Result>(
    worker: (Request) -> Result,
    options: RefreshSchedulerOptions<Request>
): RefreshScheduler<Request, Result>
    local self: Private<Request, Result> = {
        _worker = worker,
        _cache = {},
        _threads = {},
        _newlySubmitted = {},
        _newlySubmittedQueue = {},
        _refreshQueue = {},
        _getKey = options.getKey,
        _rateLimitBudget = options.rateLimitBudget,
        _incrementRateLimitBudget = {},
        _concurrencyBudget = options.concurrencyBudget or 1,
        _rateLimitInterval = options.rateLimitInterval or 60,
        _defaultRefreshInterval = options.refreshInterval or math.huge,
        _clock = options.clock or os.clock,
        _disconnect = nil,
        _onError = options.onError,

        _onChange = Signal.new(),

        _work = nil :: any,
        _consumeBudget = nil :: any,
        _insertResult = nil :: any,
        _addToRefreshQueue = nil :: any,
    }

    if options.tickInterval then
        self._disconnect =
            Teardown.fn(loopWhile(options.tickInterval, function(_deltaTime: number): boolean
                (self :: PrivateRefreshScheduler<Request, Result>):tick()

                return true
            end))
    end

    return setmetatable(self, RefreshSchedulerMetatable) :: any
end

function RefreshScheduler:getResult<Request, Result>(request: Request): Result?
    local self: PrivateRefreshScheduler<Request, Result> = self :: any

    local key: string = if self._getKey then self._getKey(request) else request :: any

    if _G.DEV then
        assertRequestKey(key)
    end

    local value = self._cache[key]
    return if value then value.value else nil
end

function RefreshScheduler:submit<Request, Result>(request: Request, refreshInterval: number?)
    local self: PrivateRefreshScheduler<Request, Result> = self :: any

    local key: string = if self._getKey then self._getKey(request) else request :: any

    if _G.DEV then
        assertRequestKey(key)
        assert(
            refreshInterval == nil or refreshInterval ~= 0,
            'attempt to use a refreshInterval of 0'
        )
        assert(
            refreshInterval == nil or refreshInterval > 0,
            'attempt to use a negative refreshInterval'
        )
    end

    if self._cache[key] ~= nil or self._threads[key] ~= nil or self._newlySubmitted[key] ~= nil then
        return
    end

    local actualRefreshInterval = refreshInterval or self._defaultRefreshInterval

    self._newlySubmitted[key] = request
    table.insert(self._newlySubmittedQueue, {
        key = key,
        request = request,
        refreshInterval = if Math.isFinite(actualRefreshInterval)
            then actualRefreshInterval
            else nil,
    })
end

function RefreshScheduler:remove<Request, Result>(request: Request)
    local self: PrivateRefreshScheduler<Request, Result> = self :: any

    local key: string = if self._getKey then self._getKey(request) else request :: any

    if _G.DEV then
        assertRequestKey(key)
    end

    local existingThread = self._threads[key]
    local existingRequest = self._newlySubmitted[key]

    self._cache[key] = nil
    self._threads[key] = nil
    self._newlySubmitted[key] = nil

    if existingRequest then
        for i, work in self._newlySubmittedQueue do
            if work.key == key then
                table.remove(self._newlySubmittedQueue, i)
                break
            end
        end
    end

    for i, work in self._refreshQueue do
        if work.key == key then
            table.remove(self._refreshQueue, i)
            break
        end
    end

    if existingThread then
        if coroutine.status(existingThread) ~= 'dead' then
            self._concurrencyBudget += 1
        end
        task.cancel(existingThread)
    end
end

function RefreshScheduler:tick<Request, Result>()
    local self: PrivateRefreshScheduler<Request, Result> = self :: any

    local currentTime = self._clock()

    local removeCount = 0
    for _, timestamps in self._incrementRateLimitBudget do
        if timestamps < currentTime then
            self._rateLimitBudget += 1
            removeCount += 1
        else
            break
        end
    end

    self._incrementRateLimitBudget = Array.popFirst(self._incrementRateLimitBudget, removeCount)

    -- selene: allow(empty_loop)
    repeat
    until not self:_work()
end

function RefreshScheduler:teardown<Request, Result>()
    local self: PrivateRefreshScheduler<Request, Result> = self :: any

    local threads = self._threads
    local disconnect = self._disconnect

    self._cache = {}
    self._threads = {}
    self._newlySubmitted = {}
    self._disconnect = nil

    for _, thread in threads do
        task.cancel(thread)
    end

    if disconnect then
        disconnect()
    end
end

function RefreshScheduler:onChange<Request, Result>(callback: (Request, Result) -> ()): () -> ()
    local self: PrivateRefreshScheduler<Request, Result> = self :: any

    return self._onChange:connect(callback):disconnectOnceFn()
end

function RefreshScheduler:_work<Request, Result>(): boolean
    local self: PrivateRefreshScheduler<Request, Result> = self :: any

    if self._rateLimitBudget == 0 or self._concurrencyBudget == 0 then
        return false
    end

    for _, work in self._newlySubmittedQueue do
        local key = work.key

        if self._threads[key] == nil then
            self:_consumeBudget()

            local thread = task.defer(function()
                local success, result = pcall(self._worker, work.request)

                self._concurrencyBudget += 1
                self._threads[key] = nil

                local index = table.find(self._newlySubmittedQueue, work)
                local queuedItem = if index
                    then table.remove(self._newlySubmittedQueue, index)
                    else nil

                if success then
                    self._newlySubmitted[key] = nil

                    self:_insertResult(key, work.request, result)

                    if work.refreshInterval then
                        self:_addToRefreshQueue(key, work.request, work.refreshInterval)
                    end
                else
                    if queuedItem then
                        table.insert(self._newlySubmittedQueue, queuedItem)
                    end
                    if self._onError then
                        self._onError(result, work.request)
                    end
                end
            end)

            self._threads[key] = thread

            return true
        end
    end

    local currentTime = self._clock()

    for i, work in self._refreshQueue do
        if work.timestamp <= currentTime then
            local key = work.key

            if self._threads[key] == nil then
                self:_consumeBudget()

                local thread = task.defer(function()
                    local success, result = pcall(self._worker, work.request)

                    self._concurrencyBudget += 1
                    self._threads[key] = nil

                    if success then
                        self:_insertResult(key, work.request, result)
                        self:_addToRefreshQueue(key, work.request, work.refreshInterval)
                    elseif _G.DEV then
                        warn(tostring(result))
                    end
                end)

                self._threads[key] = thread

                table.remove(self._refreshQueue, i)

                return true
            end
        else
            break
        end
    end

    return false
end

function RefreshScheduler:_consumeBudget<Request, Result>()
    local self: PrivateRefreshScheduler<Request, Result> = self :: any

    self._concurrencyBudget -= 1
    self._rateLimitBudget -= 1
    table.insert(self._incrementRateLimitBudget, self._clock() + self._rateLimitInterval)
end

function RefreshScheduler:_insertResult<Request, Result>(key: string, request: Request, result: Result)
    local self: PrivateRefreshScheduler<Request, Result> = self :: any

    local current = self._cache[key]
    if current == nil or current.value ~= result then
        self._cache[key] = { value = result }
        self._onChange:fire(request, result)
    end
end

function RefreshScheduler:_addToRefreshQueue<Request, Result>(key: string, request: Request, refreshInterval: number)
    local self: PrivateRefreshScheduler<Request, Result> = self :: any

    local timestamp = self._clock() + refreshInterval

    local found = nil
    for i, work in self._refreshQueue do
        if work.timestamp > timestamp then
            found = i
            break
        end
    end

    local work = {
        key = key,
        request = request,
        timestamp = timestamp,
        refreshInterval = refreshInterval,
    }

    if found then
        table.insert(self._refreshQueue, found, work)
    else
        table.insert(self._refreshQueue, work)
    end
end

return RefreshScheduler
