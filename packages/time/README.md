[![checks](https://github.com/Aceworks-Studio/roblox-utils/actions/workflows/test.yml/badge.svg)](https://github.com/Aceworks-Studio/roblox-utils/actions/workflows/test.yml)
![version](https://img.shields.io/github/package-json/v/Aceworks-Studio/roblox-utils)
[![GitHub top language](https://img.shields.io/github/languages/top/Aceworks-Studio/roblox-utils)](https://github.com/luau-lang/luau)
![license](https://img.shields.io/npm/l/@aceworks-studio/time)
![npm](https://img.shields.io/npm/dt/@aceworks-studio/time)

# @aceworks-studio/time

A set of utility functions around time.

## Installation

Add `@aceworks-studio/time` in your dependencies:

```bash
yarn add @aceworks-studio/time
```

Or if you are using `npm`:

```bash
npm install @aceworks-studio/time
```

## Content

### debounce

```lua
function debounce<R, T...>(durationSeconds: number, fn: (T...) -> R): (T...) -> R?
```

Returns a debounced version of the provided function that skips the execution until the given amount of time have elapsed since the last time it was invoked.

If `durationSeconds` is less than or equal to 0, the given function is simply returned.

### loopUntil

```lua
function loopUntil(interval: Interval, fn: (deltaTime: number) -> boolean): () -> ()
```

Continuously calls a function at specified intervals until a condition is met or an optional timeout is reached. The timeout can be provided using the [interval type](#interval-type).

Returns a function that cancel the loop.

### loopWhile

```lua
function loopWhile(interval: Interval, fn: (deltaTime: number) -> boolean): () -> ()
```

Continuously calls a function at specified intervals while a condition is met. An optional timeout can be be provided using the [interval type](#interval-type).

Returns a function that cancel the loop.

### noYield

```lua
function noYield<T..., R...>(fn: (T...) -> R..., ...: T...): R...
```

Executes a function ensuring that it does not yield. If the function attempts to yield, an error is thrown. This is particularly useful in development environments to enforce non-yielding behavior.

### throttle

```lua
function throttle<R..., T...>(durationSeconds: number, fn: (T...) -> R...): (T...) -> ()
```

Returns a throttled version of the provided function that only allows it to be called at most once every `durationSeconds`.

If the function is called more frequently, the calls are delayed until the duration has passed.

### yieldUntil

```lua
function yieldUntil(interval: Interval, fn: (deltaTime: number) -> boolean)
```

Yields the current coroutine until a specified condition is met, checking the condition at regular intervals specified by `interval`. Continues to yield and check the condition until it is met or an optional timeout is reached.

The timeout can be provided using the [interval type](#interval-type).

### Interval Type

```lua
type Interval = number | { interval: number, duration: number? }
```

The exported type `Interval` is used to provide a time interval in seconds with an optional maximum duration (in seconds too).

### RefreshScheduler

This utility class is designed to manage asynchronous requests efficiently within specified budgets, such as rate limits and concurrency constraints. It supports periodic refreshing of results, error handling, and provides hooks to react to changes in the request state.

It is useful for scenarios where multiple requests need to be handled concurrently while adhering to resource or rate constraints, such as API requests or task processing systems.

- [Constructor](#refreshscheduler-constructor)
- [RefreshSchedulerOptions](#refreshscheduleroptions)
- [getResult](#getresult)
- [submit](#submit)
- [remove](#remove)
- [tick](#tick)
- [teardown](#teardown)
- [onChange](#onchange)

#### RefreshScheduler Constructor

```lua
function RefreshScheduler.new<Request, Result>(
    worker: (Request) -> Result,
    options: RefreshSchedulerOptions<Request>
): RefreshScheduler<Request, Result>
```

Creates a new `RefreshScheduler` object from a `worker` function and its options.

**Parameters:**
- `worker`: A function to process requests and generate results.
- `options`: See [RefreshSchedulerOptions](#refreshscheduleroptions) for more details.

**Returns:** `RefreshScheduler<Request, Result>`

#### RefreshSchedulerOptions

This type defines the configuration options for creating a `RefreshScheduler` object. These options allow you to customize key behaviors, such as how requests are identified, rate-limiting parameters, concurrency constraints, refresh intervals and error handling.

```lua
type RefreshSchedulerOptions<Request> = {
    -- Function to generate a key for each request. Requests
    -- that generate the same key are considered to be the same
    -- requests.
    -- If not provided, the request itself must be a string.
    getKey: ((Request) -> string)?,

    -- Number of requests allowed within the rate limit interval.
    rateLimitBudget: number,

    -- The interval, in seconds, for replenishing the rate
    -- limit budget. Defaults to 60 seconds.
    rateLimitInterval: number?,

    -- Maximum number of requests that can be processed
    -- concurrently. Defaults to 1.
    concurrencyBudget: number?,

    -- Default interval, in seconds, for refreshing requests.
    -- Defaults to infinity, which means no automatic refresh.
    refreshInterval: number?,

    -- Function that returns the current time. Defaults to os.clock.
    -- Useful for testing.
    clock: (() -> number)?,

    -- The interval, in seconds, for automatically calling the `tick`
    -- method. If not provided, `tick` must be called manually.
    tickInterval: number?,

    -- A function to call whenever the `worker` encounters an error.
    -- Receives the error and the associated request as arguments.
    onError: (err: any, request: Request) -> ()?,
}
```

#### getResult

```lua
function RefreshScheduler:getResult<Request, Result>(request: Request): Result?
```

Fetches the cached result of a request if it exists.

**Parameters:**
- `request`: The request to retrieve the result for.

**Returns:** The cached result if available, otherwise `nil`.

#### submit

```lua
function RefreshScheduler:submit<Request, Result>(request: Request, refreshInterval: number?)
```

Submits a new request to the scheduler. The request will be processed by the `worker` function, and the result will be cached and refreshed at the specified interval.

**Parameters:**
- `request`: The request to submit.
- `refreshInterval`: The interval in seconds to refresh the result (default: `refreshInterval` specified in options).

#### remove

```lua
function RefreshScheduler:remove<Request, Result>(request: Request)
```

Removes a request from the scheduler, stopping any associated refresh or processing.

**Parameters:**
- `request`: The request to remove.

#### tick

```lua
function RefreshScheduler:tick<Request, Result>()
```

Manually advances the scheduler, processing any queued requests or refreshing results as needed.

**Note:** if the `tickInterval` option was specified when creating the scheduler, this function **should not be called**, as it will be called automatically.

#### teardown

```lua
function RefreshScheduler:teardown<Request, Result>()
```

Cleans up the scheduler, canceling all ongoing processes and clearing internal caches.

#### onChange

```lua
function RefreshScheduler:onChange<Request, Result>(
    callback: (Request, Result) -> ()
): () -> ()
```

Registers a function that will be called whenever the result of a request changes.

**Parameters:**
- `callback` (function): The function to call when a result changes. Receives the `request` and the new `result` as arguments.

**Returns:** A function that disconnects the listener.

## License

This project is available under the MIT license. See [LICENSE.txt](../../LICENSE.txt) for details.

## Other Lua Environments Support

If you would like to use this library on a Lua environment where it is currently incompatible, open an issue (or comment on an existing one) to request the appropriate modifications.

The library uses [darklua](https://github.com/seaofvoices/darklua) to process its code.
