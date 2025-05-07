local Disk = require('@pkg/luau-disk')

local Array = Disk.Array

export type SpatialMap<T> = {
    getMapPosition: (self: SpatialMap<T>, position: Vector3) -> Vector3,
    add: (self: SpatialMap<T>, position: Vector3, item: T) -> (Vector3?) -> (),
    getInsideRegion: (self: SpatialMap<T>, region: Region3) -> { T },
    getInsideSphere: (self: SpatialMap<T>, center: Vector3, radius: number) -> { T },
}

type LocatedItem<T> = { value: T, position: Vector3 }

type Private<T> = {
    _gridSize: Vector3,
    _spaceMap: { [Vector3]: { LocatedItem<T> } },
}
type PrivateSpatialMap<T> = SpatialMap<T> & Private<T>

type SpatialMapStatic = {
    new: <T>(gridSize: number | Vector3) -> SpatialMap<T>,

    getMapPosition: <T>(self: SpatialMap<T>, position: Vector3) -> Vector3,
    add: <T>(self: SpatialMap<T>, position: Vector3, item: T) -> (Vector3) -> (),
    getInsideRegion: <T>(self: SpatialMap<T>, region: Region3) -> { T },
    getInsideSphere: <T>(self: SpatialMap<T>, center: Vector3, radius: number) -> { T },
}

local SpatialMap: SpatialMapStatic = {} :: any
local SpatialMapMetatable = {
    __index = SpatialMap,
}

function SpatialMap.new<T>(gridSize: number | Vector3): SpatialMap<T>
    local self: Private<T> = {
        _gridSize = if type(gridSize) == 'number'
            then (1 / gridSize) * Vector3.one
            else Vector3.one / gridSize,
        _spaceMap = {},
    }

    return setmetatable(self, SpatialMapMetatable) :: any
end

function SpatialMap:add<T>(position: Vector3, item: T): (Vector3) -> ()
    local self: PrivateSpatialMap<T> = self :: any

    local value = { value = item, position = position }
    local hashPosition = self:getMapPosition(position)

    if self._spaceMap[hashPosition] == nil then
        self._spaceMap[hashPosition] = { value }
    else
        table.insert(self._spaceMap[hashPosition], value)
    end

    local removed = false

    local function updateItem(newPosition: Vector3?)
        if removed then
            return
        end

        if newPosition then
            value.position = newPosition
        end

        local newHashPosition = newPosition and self:getMapPosition(newPosition)

        if newHashPosition ~= nil and newHashPosition == hashPosition then
            return
        end

        if _G.DEV and self._spaceMap[hashPosition] == nil then
            error(`expected SpaceMap to contain an array for {hashPosition}`)
        end

        local index = table.find(self._spaceMap[hashPosition], value)

        if _G.DEV and index == nil then
            error(`expected SpaceMap to contain the item {item}`)
        end

        table.remove(self._spaceMap[hashPosition], index)

        if #self._spaceMap[hashPosition] == 0 then
            self._spaceMap[hashPosition] = nil
        end

        if newHashPosition then
            hashPosition = newHashPosition
            if self._spaceMap[newHashPosition] == nil then
                self._spaceMap[newHashPosition] = { value }
            else
                table.insert(self._spaceMap[newHashPosition], value)
            end
        else
            removed = true
        end
    end

    return updateItem
end

function SpatialMap:getMapPosition<T>(position: Vector3): Vector3
    local self: PrivateSpatialMap<T> = self :: any

    return (position * self._gridSize):Floor()
end

local function getIterationSign(startValue: number, endValue: number): number
    return if endValue < startValue then -1 else 1
end

local function getGridPoints(startPosition: Vector3, endPosition: Vector3): { Vector3 }
    local points = {}
    for x = startPosition.X, endPosition.X, getIterationSign(startPosition.X, endPosition.X) do
        for y = startPosition.Y, endPosition.Y, getIterationSign(startPosition.Y, endPosition.Y) do
            for z = startPosition.Z, endPosition.Z, getIterationSign(startPosition.Z, endPosition.Z) do
                table.insert(points, Vector3.new(x, y, z))
            end
        end
    end
    return points
end

function SpatialMap:getInsideRegion<T>(region: Region3): { T }
    local self: PrivateSpatialMap<T> = self :: any

    local regionLocation = region.CFrame
    local halfSize = region.Size / 2
    local startPosition = self:getMapPosition(regionLocation:PointToWorldSpace(halfSize))
    local endPosition = self:getMapPosition(regionLocation:PointToWorldSpace(-halfSize))

    local items: { LocatedItem<T> } = if startPosition == endPosition
        then self._spaceMap[startPosition] or {}
        else Array.flatMap(getGridPoints(startPosition, endPosition), function(position)
            return self._spaceMap[position]
        end)

    return Array.map(items, function(item)
        local itemPosition = regionLocation:PointToObjectSpace(item.position):Abs()

        return if itemPosition.X <= halfSize.X
                and itemPosition.Y <= halfSize.Y
                and itemPosition.Z <= halfSize.Z
            then item.value
            else nil
    end)
end

function SpatialMap:getInsideSphere<T>(center: Vector3, radius: number): { T }
    local self: PrivateSpatialMap<T> = self :: any

    local startPosition = self:getMapPosition(center + radius * Vector3.one)
    local endPosition = self:getMapPosition(center - radius * Vector3.one)

    local items: { LocatedItem<T> } = if startPosition == endPosition
        then self._spaceMap[startPosition] or {}
        else Array.flatMap(getGridPoints(startPosition, endPosition), function(position)
            return self._spaceMap[position]
        end)

    return Array.map(items, function(item)
        local itemPosition = item.position - center

        return if itemPosition.Magnitude <= radius then item.value else nil
    end)
end

return SpatialMap
