[![checks](https://github.com/Aceworks-Studio/roblox-utils/actions/workflows/test.yml/badge.svg)](https://github.com/Aceworks-Studio/roblox-utils/actions/workflows/test.yml)
![version](https://img.shields.io/github/package-json/v/Aceworks-Studio/roblox-utils)
[![GitHub top language](https://img.shields.io/github/languages/top/Aceworks-Studio/roblox-utils)](https://github.com/luau-lang/luau)
![license](https://img.shields.io/npm/l/@aceworks-studio/spatial-data)
![npm](https://img.shields.io/npm/dt/@aceworks-studio/spatial-data)

# @aceworks-studio/spatial-data

A Luau utility to work with spatial data. Currently contains only a SpatialMap class, but in the future it will also include an Octree implementation.

## Installation

Add `@aceworks-studio/spatial-data` in your dependencies:

```bash
yarn add @aceworks-studio/spatial-data
```

Or if you are using `npm`:

```bash
npm install @aceworks-studio/spatial-data
```

## Content

- [SpatialMap](#spatialmap)
  - [new](#new)
  - [getMapPosition](#getmapposition)
  - [add](#add)
  - [getInsideRegion](#getinsideregion)
  - [getInsideSphere](#getinsidesphere)

### SpatialMap

A container of points that can be queried to associated items.

The `SpatialMap` class and type can be obtained from the module like this:

```lua
local SpatialData = require("@pkg/@aceworks-studio/spatial-data")

local SpatialMap = SpatialData.SpatialMap
type SpatialMap<T> = SpatialData.SpatialMap<T>
```

#### new

```lua
function SpatialMap.new<T>(gridSize: number | Vector3): SpatialMap<T>
```

Creates a new `SpatialMap` instance with a specified grid size. The grid size determines the resolution of the spatial map, and it can be provided as either a single number or a `Vector3`.

#### getMapPosition

```lua
function SpatialMap:getMapPosition(position: Vector3): Vector3
```

Computes the grid-aligned position for a given `position` in world space.

#### add

```lua
function SpatialMap:add(position: Vector3, item: T): (Vector3?) -> ()
```

Adds an item to the spatial map at the specified `position`. Returns a function that can be used to update the item's position or remove it from the map.

**Example:**

```lua
local objectMap = SpatialMap.new(25)
-- ...
local value = { ... }
local updateValue = objectMap:add(Vector3.new(1.5, 0, 1), newObject)

-- to update the location of the value, call the function with the new
-- coordinates
updateValue(Vector3.new(1.7, 0, 1.1))

-- to remove the value from the SpatialMap, call the function with nil
updateValue(nil)
```

#### getInsideRegion

```lua
function SpatialMap:getInsideRegion(region: Region3): { T }
```

Retrieves all items located within the given `Region3`. Region3 are boxes aligned on all axis.

#### getInsideSphere

```lua
function SpatialMap:getInsideSphere(center: Vector3, radius: number): { T }
```

Retrieves all items located within a spherical area defined by a `center` and `radius`. Only items within the sphere are returned.

## License

This project is available under the MIT license. See [LICENSE.txt](../../LICENSE.txt) for details.

## Other Lua Environments Support

If you would like to use this library on a Lua environment where it is currently incompatible, open an issue (or comment on an existing one) to request the appropriate modifications.

The library uses [darklua](https://github.com/seaofvoices/darklua) to process its code.
