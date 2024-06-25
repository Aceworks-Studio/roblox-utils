[![checks](https://github.com/Aceworks-Studio/roblox-utils/actions/workflows/test.yml/badge.svg)](https://github.com/Aceworks-Studio/roblox-utils/actions/workflows/test.yml)
![version](https://img.shields.io/github/package-json/v/Aceworks-Studio/roblox-utils)
[![GitHub top language](https://img.shields.io/github/languages/top/Aceworks-Studio/roblox-utils)](https://github.com/luau-lang/luau)
![license](https://img.shields.io/npm/l/@aceworks-studio/random)
![npm](https://img.shields.io/npm/dt/@aceworks-studio/random)

# @aceworks-studio/random

A Luau utility library to work with randomness.

## Installation

Add `@aceworks-studio/random` in your dependencies:

```bash
yarn add @aceworks-studio/random
```

Or if you are using `npm`:

```bash
npm install @aceworks-studio/random
```

## Content

- values
  - [boolean](#boolean)
  - character
    - [pick](#characterpick)
    - [letter](#characterletter)
    - [upperCaseLetter](#characterupperCaseLetter)
    - [lowerCaseLetter](#characterlowerCaseLetter)
    - [digit](#characterdigit)
    - [alphaNumeric](#characteralphaNumeric)
    - [hexDigit](#characterhexDigit)
  - color
    - [saturated](#colorsaturated)
    - [brightness](#colorbrightness)
    - [spreadHue](#colorspreadHue)
    - [gray](#colorgray)
    - [black](#colorblack)
    - [white](#colorwhite)
  - [enum](#enum)
  - [number](#number)
    - [between](#numberbetween)
    - [spread](#numberspread)
    - [sign](#numbersign)
    - integer
      - [above](#numberintegerabove)
      - [aboveOrEqual](#numberintegeraboveorequal)
      - [below](#numberintegerbelow)
      - [belowOrEqual](#numberintegerbeloworequal)
      - [between](#numberintegerbetween)
  - [string](#string)
    - [ofLength](#stringofLength)
    - [between](#stringbetween)
    - [substring](#stringsubstring)
  - [vector2](#vector2)
    - [unit](#vector2unit)
    - [ofLength](#vector2ofLength)
    - [inCircle](#vector2inCircle)
    - [inRectangle](#vector2inRectangle)
  - [vector3](#vector3)
    - [unit](#vector3unit)
    - [ofLength](#vector3ofLength)
    - [inSphere](#vector3inSphere)
    - [inBox](#vector3inBox)
- array
  - [ofLength](#arrayoflength)
  - [between](#arraybetween)
  - [shuffle](#arrayshuffle)
  - [shuffleInPlace](#arrayshuffleinplace)
  - [pickOne](#arraypickone)
  - [pickMultiple](#arraypickmultiple)
  - [pickMultipleOnce](#arraypickmultipleonce)
- weighted
  - [array](#weightedarray)
  - [map](#weightedmap)
  - [WeightedChoiceGenerator](#weightedchoicegenerator)

### create

```lua
function create(random: Random): RandomGenerator
```

This creates a new instance of the library where each function will use the given `random` object.

### values

Contains various utilities to generate simple values.

#### boolean

```lua
function boolean(chance: number?): boolean
```

Returns `true` or `false`. The `chance` argument tells how likely the boolean will be `true` and it must be between 0 and 1 (default is 0.5).

#### character.pick

```lua
function character.pick(characters: string): string
```

Returns one character from the given `characters` string.

#### character.letter

```lua
function character.letter(): string
```

Returns one letter from the english alphabet (upper or lower case).

#### character.upperCaseLetter

```lua
function character.upperCaseLetter(): string
```

Returns one upper case letter from the english alphabet.

#### character.lowerCaseLetter

```lua
function character.lowerCaseLetter(): string
```

Returns one lower case letter from the english alphabet.

#### character.digit

```lua
function character.digit(): string
```

Returns a digit (`0-9`).

#### character.alphaNumeric

```lua
function character.alphaNumeric(): string
```

Returns a digit or a letter from the english alphabet (upper or lower case).

#### character.hexDigit

```lua
function character.hexDigit(): string
```

Returns a digit from an hexadecimal base (`0-9` or `A-F`).


#### color.saturated

```lua
function color.saturated(saturation: number?, value: number?): Color3
```

Returns a random color with the given saturation and value.

- `saturation`: between 0 and 1 (default is 1)
- `value`: between 0 and 1 (default is 1)

#### color.brightness

```lua
function color.brightness(hue: number, saturation: number?): Color3
```

Returns a random color with a random brightness.

- `hue`: between 0 and 1
- `saturation`: between 0 and 1 (default is 1)

#### color.spreadHue

```lua
function color.spreadHue(color: Color3, hueSpan: number): Color3
```

Returns a random color where the hue is shifted by a maximum amount given by `hueSpan`. A `hueSpan` of 1 means that it can shift across all colors.

#### color.gray

```lua
function color.gray(): Color3
```

Returns a random gray color.

#### color.black

```lua
function color.black(chance: number?, fallback: Color3?): Color3
```

Returns black randomly using the given `chance` value.

- `chance`: how likely the color will be black, between 0-1 (default is 0.5).
- `fallback`: default is white

#### color.white

```lua
function color.white(chance: number?, fallback: Color3?): Color3
```

- `chance`: how likely the color will be white, between 0-1 (default is 0.5).
- `fallback`: default is black

#### enum

```lua
function enum(enum: Enum): Enumitem
```

Returns a random enum item from an enum. Example:

```lua
local randomMaterial = values.enum(Enum.Material)
```

#### number.between

```lua
function number.between(
    minValue: number,
    maxValue: number,
    decimals: number?
): number
```

Returns a number between the given bounds and rounds it with the given number of decimals (if provided)

#### number.spread

```lua
function number.spread(value: number, span: number): number
```

Returns a random number shifted by a maximum amount given by `span`. The generated number will be between `[value - span/2, value + span/2]`.

#### number.sign

```lua
function number.sign(positiveChance: number?): number
```

Returns `1` or `-1`.

- `positiveChance`: how likely (`[0-1]`) it is to return `1` (default is 0.5).

#### number.integer.above

```lua
function number.integer.above(value: number): number
```

Returns a number above `value` and the largest safe integer, without including `value`.

#### number.integer.aboveOrEqual

```lua
function number.integer.aboveOrEqual(value: number): number
```

Returns a number above or equal to `value` and the largest safe integer.

#### number.integer.below

```lua
function number.integer.below(value: number): number
```

Returns a number below `value` and the smallest safe integer, without including `value`.

#### number.integer.belowOrEqual

```lua
function number.integer.belowOrEqual(value: number): number
```

Returns a number below or equal to `value` and the smallest safe integer.

#### number.integer.between

```lua
function number.integer.between(minValue: number, maxValue: number): number
```

Returns an integer between the provided bounds.

#### string.ofLength

```lua
function string.ofLength(
    length: number,
    characterGenerator: CharacterSetGenerator
): string
-- where
type CharacterSetGenerator = string | (() -> string)?
```

Returns a string of the given `length`. Uses the `characterGenerator` to fill each character.

#### string.between

```lua
function string.between(
    minLength: number,
    maxLength: number,
    characterGenerator: CharacterSetGenerator
): string
-- where
type CharacterSetGenerator = string | (() -> string)?
```

Returns a string of a random length between the given bounds. Uses the `characterGenerator` to fill each character.

#### string.substring

```lua
function string.substring(value: string, length: number?): string
```

Returns a substring of the given `value`. If the `length` is not provided, it uses chooses a random length between 1 and the length of `value`.

#### vector2.unit

```lua
function vector2.unit(): Vector2
```

Returns a Vector2 of length equal to 1.

#### vector2.ofLength

```lua
function vector2.ofLength(length: number): Vector2
```

Returns a Vector2 the given length.

#### vector2.inCircle

```lua
function vector2.inCircle(radius: number, center: Vector2?): Vector2
```

Returns a Vector2 within the bounds of a circle centered at `center` (default to `(0, 0)`).

#### vector2.inRectangle

```lua
function vector2.inRectangle(rectangle: Rectangle): Vector2
-- where
type Rectangle =
    { size: Vector2, center: Vector2 }
    | { pointA: Vector2, pointB: Vector2 }
```

Returns a Vector2 within the bounds of the provided rectangle.

#### vector3.unit

```lua
function vector3.unit(): Vector3
```

Returns a Vector3 of length equal to 1.

#### vector3.ofLength

```lua
function vector3.ofLength(length: number): Vector3
```

Returns a Vector3 the given length.

#### vector3.inSphere

```lua
function vector3.inSphere(radius: number, center: Vector3?): Vector3
```

Returns a Vector3 within the bounds of a sphere centered at `center` (default to `(0, 0, 0)`).

#### vector3.inBox

```lua
function vector3.inBox(size: Vector3, center: Vector3): Vector3
```

Returns a Vector3 within the bounds of a sphere centered at `center` (default to `(0, 0, 0)`).

### array.ofLength

```lua
function array.ofLength<T>(length: number, generator: () -> T) -> { T },
```

Creates an array of the given length using the generator function.

### array.between

```lua
function array.between<T>(minLength: number, maxLength: number, generator: () -> T) -> { T },
```

Creates an array of a random length between the given bounds using the generator function.

### array.shuffle

```lua
function array.shuffle<T>(array: { T }) -> { T },
```

Returns a new array with the same elements in a different order.

This function does not modify the original array.

### array.shuffleInPlace

```lua
function array.shuffleInPlace<T>(array: { T }) -> (),
```

Mutates an array to mix the elements in a different order.

### array.pickOne

```lua
function array.pickOne<T>(array: { T }) -> T?,
```

Returns one element from the array. Returns `nil` if `array` is empty.

### array.pickMultiple

```lua
function array.pickMultiple<T>(array: { T }, count: number) -> { T },
```

Returns a new array with `count` elements picked from `array`. The returned array may be empty if `array` is empty.

### array.pickMultipleOnce

```lua
function array.pickMultipleOnce<T>(array: { T }, count: number) -> { T },
```

Similar to `pickMultiple`, but it returns a new array with `count` elements picked from `array` **only once**. The returned array cannot be larger than the provided `array` and it may be empty if `array` is empty.

#### weighted.array

#### weighted.map

```lua
function weighted.array<T>(elements: { T }, weights: { number }): WeightedChoiceGenerator<T>
```

Creates a [WeightedChoiceGenerator](#weightedchoicegenerator) that can pick values from `elements`. Each relative probability of the values in `elements` are provided through `weights`.

```lua
function weighted.map<T>(map: { [T]: number }): WeightedChoiceGenerator<T>
```

Creates a [WeightedChoiceGenerator](#weightedchoicegenerator) that can pick values from the keys of `map`. Each key is mapped to the relative probability to get picked.

#### WeightedChoiceGenerator

Provides functions to build a `WeightedChoiceGenerator<T>` from a set of choices and their relative probability weights. It has these three functions:

```lua
function pickOne(): T?
```

Returns one element from the array. Returns `nil` if the original array is empty.

```lua
function pickMultiple(count: number): { T }
```

Returns a new array with `count` elements picked from the original array. The returned array may be empty if the original array is empty.

```lua
function pickMultipleOnce(count: number): { T }
```

Similar to `pickMultiple`, but it returns a new array with `count` elements picked from original array **only once**. The returned array cannot be larger than the original array and it may be empty if original array is empty.

## License

This project is available under the MIT license. See [LICENSE.txt](../../LICENSE.txt) for details.

## Other Lua Environments Support

If you would like to use this library on a Lua environment where it is currently incompatible, open an issue (or comment on an existing one) to request the appropriate modifications.

The library uses [darklua](https://github.com/seaofvoices/darklua) to process its code.
