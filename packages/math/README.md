[![checks](https://github.com/Aceworks-Studio/roblox-utils/actions/workflows/test.yml/badge.svg)](https://github.com/Aceworks-Studio/roblox-utils/actions/workflows/test.yml)
![version](https://img.shields.io/github/package-json/v/Aceworks-Studio/roblox-utils)
[![GitHub top language](https://img.shields.io/github/languages/top/Aceworks-Studio/roblox-utils)](https://github.com/luau-lang/luau)
![license](https://img.shields.io/npm/l/@aceworks-studio/math)
![npm](https://img.shields.io/npm/dt/@aceworks-studio/math)

# @aceworks-studio/math

A set of utility functions related to math or numbers.

## Installation

Add `@aceworks-studio/math` in your dependencies:

```bash
yarn add @aceworks-studio/math
```

Or if you are using `npm`:

```bash
npm install @aceworks-studio/math
```

## Content

### isFinite

```lua
function isFinite(value: number): boolean
```

Returns `true` if the number not equal to infinity (or negative infinity) or [`NaN`](https://en.wikipedia.org/wiki/NaN).

### isInteger

```lua
function isInteger(value: number): boolean
```

Returns `true` if the number is [finite](#isfinite) and a whole number (no decimal part).

### isNaN

```lua
function isNaN(value: number): boolean
```

Returns `true` if the number is [`NaN`](https://en.wikipedia.org/wiki/NaN).

### lerp

```lua
function lerp(initialValue: number, finalValue: number, alpha: number): number
```

Returns a number interpolated between an initial value and a final value using a number `alpha` between 0 and 1.

## License

This project is available under the MIT license. See [LICENSE.txt](../../LICENSE.txt) for details.

## Other Lua Environments Support

If you would like to use this library on a Lua environment where it is currently incompatible, open an issue (or comment on an existing one) to request the appropriate modifications.

The library uses [darklua](https://github.com/seaofvoices/darklua) to process its code.
