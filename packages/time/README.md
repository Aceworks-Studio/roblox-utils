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

## License

This project is available under the MIT license. See [LICENSE.txt](../../LICENSE.txt) for details.

## Other Lua Environments Support

If you would like to use this library on a Lua environment where it is currently incompatible, open an issue (or comment on an existing one) to request the appropriate modifications.

The library uses [darklua](https://github.com/seaofvoices/darklua) to process its code.
