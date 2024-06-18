type VectorGenerator<T> = {
    unit: () -> T,
    ofLength: (length: number) -> T,
}

type Rectangle =
    { size: Vector2, center: Vector2, pointA: nil, pointB: nil }
    | { pointA: Vector2, pointB: Vector2, size: nil, center: nil }

export type Vector2Generator = VectorGenerator<Vector2> & {
    inCircle: (radius: number, center: Vector2?) -> Vector2,
    inRectangle: (rectangle: Rectangle) -> Vector2,
}
export type Vector3Generator = VectorGenerator<Vector3> & {
    inSphere: (radius: number, center: Vector3?) -> Vector3,
    inVolume: (size: Vector3, center: Vector3) -> Vector3,
}

export type VectorsGenerator = {
    vector2: Vector2Generator,
    vector3: Vector3Generator,
}

local function createVectorGenerators(random: Random): VectorsGenerator
    local function vector2Unit(): Vector2
        local angle = random:NextNumber() * 2 * math.pi
        return Vector2.new(math.cos(angle), math.sin(angle)).Unit
    end

    local function vector3Unit(): Vector3
        local value = random:NextUnitVector()
        return value
    end

    local function vector2OfLength(length: number): Vector2
        local angle = random:NextNumber() * 2 * math.pi
        return length * Vector2.new(math.cos(angle), math.sin(angle)).Unit
    end

    local function vector3OfLength(length: number): Vector3
        local value = random:NextUnitVector()
        return value * length
    end

    local function inCircle(radius: number, center: Vector2?): Vector2
        local angle = random:NextNumber() * 2 * math.pi

        local centerX = 0
        local centerY = 0
        if center ~= nil then
            centerX = center.X
            centerY = center.Y
        end

        local actualRadius = radius * random:NextNumber()

        return Vector2.new(
            centerX + actualRadius * math.cos(angle),
            centerY + actualRadius * math.sin(angle)
        )
    end

    local function inRectangle(rectangle: Rectangle): Vector2
        if rectangle.center == nil then
            local pointA = rectangle.pointA :: Vector2
            local pointB = rectangle.pointB :: Vector2
            local width = math.abs(pointA.X - pointB.X)
            local height = math.abs(pointA.Y - pointB.Y)
            local x = random:NextNumber()
            local y = random:NextNumber()
            return Vector2.new(
                math.min(pointA.X, pointB.X) + x * width,
                math.min(pointA.Y, pointB.Y) + y * height
            )
        else
            local x = random:NextNumber() - 0.5
            local y = random:NextNumber() - 0.5
            local size = rectangle.size
            return rectangle.center + Vector2.new(size.X * x, size.Y * y)
        end
    end

    local function inSphere(radius: number, center: Vector3?): Vector3
        local angle = random:NextUnitVector()
        local actualRadius = radius * random:NextNumber()
        return (center or Vector3.zero) + angle * actualRadius
    end

    local function inVolume(size: Vector3, center: Vector3?): Vector3
        local x = random:NextNumber() - 0.5
        local y = random:NextNumber() - 0.5
        local z = random:NextNumber() - 0.5
        return (center or Vector3.zero) + size * Vector3.new(x, y, z)
    end

    return {
        vector2 = {
            unit = vector2Unit,
            ofLength = vector2OfLength,
            inCircle = inCircle,
            inRectangle = inRectangle,
        },
        vector3 = {
            unit = vector3Unit,
            ofLength = vector3OfLength,
            inSphere = inSphere,
            inVolume = inVolume,
        },
    }
end

return createVectorGenerators
