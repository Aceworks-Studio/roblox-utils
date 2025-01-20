local JestGlobals = require('@pkg/@jsdotlua/jest-globals')

local SpatialMap = require('../SpatialMap')

local expect = JestGlobals.expect
local it = JestGlobals.it
local describe = JestGlobals.describe
local beforeEach = JestGlobals.beforeEach

local map = nil
local gridSize = Vector3.new(2, 2.5, 3)

beforeEach(function()
    map = SpatialMap.new(gridSize)
end)

local positions = {
    Vector3.zero,
    Vector3.xAxis,
    Vector3.yAxis,
    Vector3.zAxis,
    100 * Vector3.xAxis,
    100 * Vector3.yAxis,
    100 * Vector3.zAxis,
    Vector3.one,
    100 * Vector3.one,
    Vector3.new(2, 4, 5),
    Vector3.new(0.1, 0.5, 10.77),
}

describe('getInsideSphere', function()
    for _, position in positions do
        it(`adds an item and get it back from the same position at ({position})`, function()
            local item = 'oof'

            map:add(position, item)

            expect(map:getInsideSphere(position, 0.5)).toEqual({ item })
        end)

        local awayFactor = 10
        local awayFromPosition = position + awayFactor * gridSize

        it(`adds an item at ({position}) but cannot get it back at ({awayFromPosition})`, function()
            local item = 'oof'

            map:add(position, item)

            expect(map:getInsideSphere(awayFromPosition, awayFactor / 2)).toEqual({})
        end)
    end
end)

describe('getInsideRegion', function()
    for _, position in positions do
        it(`adds an item and get it back from the same position at ({position})`, function()
            local item = 'oof'

            map:add(position, item)

            local region = Region3.new(position - Vector3.one, position + Vector3.one)

            expect(map:getInsideRegion(region)).toEqual({ item })
        end)

        local awayFactor = 10
        local awayFromPosition = position + awayFactor * gridSize

        it(`adds an item at ({position}) but cannot get it back at ({awayFromPosition})`, function()
            local item = 'oof'

            map:add(position, item)

            local region =
                Region3.new(awayFromPosition, awayFromPosition + awayFactor * Vector3.one)

            expect(map:getInsideRegion(region)).toEqual({})
        end)
    end
end)
