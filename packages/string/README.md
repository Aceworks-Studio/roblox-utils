[![checks](https://github.com/Aceworks-Studio/roblox-utils/actions/workflows/test.yml/badge.svg)](https://github.com/Aceworks-Studio/roblox-utils/actions/workflows/test.yml)
![version](https://img.shields.io/github/package-json/v/Aceworks-Studio/roblox-utils)
[![GitHub top language](https://img.shields.io/github/languages/top/Aceworks-Studio/roblox-utils)](https://github.com/luau-lang/luau)
![license](https://img.shields.io/npm/l/@aceworks-studio/string)
![npm](https://img.shields.io/npm/dt/@aceworks-studio/string)

# @aceworks-studio/string

A set of utility functions for string manipulation.

## Installation

Add `@aceworks-studio/string` in your dependencies:

```bash
yarn add @aceworks-studio/string
```

Or if you are using `npm`:

```bash
npm install @aceworks-studio/string
```

## Content

### contains

```lua
function contains(value: string, substring: string): boolean
```

Checks if the given string `value` contains `substring`.

### endsWith

```lua
function endsWith(value: string, suffix: string): boolean
```

Checks if the given string `value` ends with the specified suffix `suffix`. Returns `true` if `value` ends with `suffix`, otherwise `false`.

### startsWith

```lua
function startsWith(value: string, prefix: string): boolean
```

Checks if the given string `value` starts with the specified prefix `prefix`. Returns `true` if `value` starts with `prefix`, otherwise `false`.

### trim

```lua
function trim(value: string): string
```

Removes whitespace from both ends of the given string. Returns the trimmed string.

### trimEnd

```lua
function trimEnd(value: string): string
```

Removes whitespace from the end of the given string. Returns the trimmed string.

### trimStart

```lua
function trimStart(value: string): string
```

Removes whitespace from the beginning of the given string. Returns the trimmed string.


## License

This project is available under the MIT license. See [LICENSE.txt](../../LICENSE.txt) for details.

## Other Lua Environments Support

If you would like to use this library on a Lua environment where it is currently incompatible, open an issue (or comment on an existing one) to request the appropriate modifications.

The library uses [darklua](https://github.com/seaofvoices/darklua) to process its code.
