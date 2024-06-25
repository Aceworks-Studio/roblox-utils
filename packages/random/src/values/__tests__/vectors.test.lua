local JestGlobals = require('@pkg/@jsdotlua/jest-globals')

local createVectors = require('../vectors')

local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeAll = JestGlobals.beforeAll
local describe = JestGlobals.describe

local FUZZ_COUNT = 20

local generator

beforeAll(function()
    generator = createVectors(Random.new())
end)

describe('unit', function()
    it('returns Vector2 of length = 1', function()
        for _ = 1, FUZZ_COUNT do
            local value = generator.vector2.unit()

            expect(value.Magnitude).toBeCloseTo(1)
        end
    end)

    it('returns Vector3 of length = 1', function()
        for _ = 1, FUZZ_COUNT do
            local value = generator.vector3.unit()

            expect(value.Magnitude).toBeCloseTo(1)
        end
    end)
end)

describe('ofLength', function()
    it('returns Vector2 of length = 1', function()
        for i = 1, FUZZ_COUNT do
            local value = generator.vector2.ofLength(i)

            expect(value.Magnitude).toBeCloseTo(i)
        end
    end)

    it('returns Vector3 of length = 1', function()
        for i = 1, FUZZ_COUNT do
            local value = generator.vector3.ofLength(i)

            expect(value.Magnitude).toBeCloseTo(i)
        end
    end)
end)

describe('inCircle', function()
    it('returns a point within the radius', function()
        for _ = 1, FUZZ_COUNT do
            local radius = 100 * math.random()
            local value = generator.vector2.inCircle(radius)

            expect(value.Magnitude).toBeLessThanOrEqual(radius)
        end
    end)

    it('returns a point within the radius given a center', function()
        for _ = 1, FUZZ_COUNT do
            local radius = 100 * math.random()
            local center = Vector2.new(100 * math.random(), 100 * math.random())
            local value = generator.vector2.inCircle(radius, center)

            expect((value - center).Magnitude).toBeLessThanOrEqual(radius)
        end
    end)
end)

describe('inSphere', function()
    it('returns a point within the radius', function()
        for _ = 1, FUZZ_COUNT do
            local radius = 100 * math.random()
            local value = generator.vector3.inSphere(radius)

            expect(value.Magnitude).toBeLessThanOrEqual(radius)
        end
    end)

    it('returns a point within the radius given a center', function()
        for _ = 1, FUZZ_COUNT do
            local radius = 100 * math.random()
            local center =
                Vector3.new(100 * math.random(), 100 * math.random(), 100 * math.random())
            local value = generator.vector3.inSphere(radius, center)

            expect((value - center).Magnitude).toBeLessThanOrEqual(radius)
        end
    end)
end)

describe('inRectangle', function()
    it('returns a point inside a rectangle defined by two points', function()
        for _ = 1, FUZZ_COUNT do
            local pointA = generator.vector2.inCircle(1000)
            local pointB = generator.vector2.inCircle(1000)
            local value = generator.vector2.inRectangle({ pointA = pointA, pointB = pointB })

            expect(value.X).toBeGreaterThanOrEqual(math.min(pointA.X, pointB.X))
            expect(value.X).toBeLessThanOrEqual(math.max(pointA.X, pointB.X))
            expect(value.Y).toBeGreaterThanOrEqual(math.min(pointA.Y, pointB.Y))
            expect(value.Y).toBeLessThanOrEqual(math.max(pointA.Y, pointB.Y))
        end
    end)

    it('returns a point inside a rectangle defined by a center and a size', function()
        for _ = 1, FUZZ_COUNT do
            local center = generator.vector2.inCircle(1000)
            local size = generator.vector2.inCircle(1000):Abs()
            local value = generator.vector2.inRectangle({ center = center, size = size })

            expect(value.X).toBeGreaterThanOrEqual(center.X - size.X / 2)
            expect(value.X).toBeLessThanOrEqual(center.X + size.X / 2)
            expect(value.Y).toBeGreaterThanOrEqual(center.Y - size.Y / 2)
            expect(value.Y).toBeLessThanOrEqual(center.Y + size.Y / 2)
        end
    end)
end)

describe('inBox', function()
    it('returns a point inside the volume', function()
        for _ = 1, FUZZ_COUNT do
            local center = generator.vector3.inSphere(1000)
            local size = generator.vector3.inSphere(100):Abs()
            local value = generator.vector3.inBox(size, center)

            expect(value.X).toBeGreaterThanOrEqual(center.X - size.X / 2)
            expect(value.X).toBeLessThanOrEqual(center.X + size.X / 2)
            expect(value.Y).toBeGreaterThanOrEqual(center.Y - size.Y / 2)
            expect(value.Y).toBeLessThanOrEqual(center.Y + size.Y / 2)
            expect(value.Z).toBeGreaterThanOrEqual(center.Z - size.Z / 2)
            expect(value.Z).toBeLessThanOrEqual(center.Z + size.Z / 2)
        end
    end)
end)
