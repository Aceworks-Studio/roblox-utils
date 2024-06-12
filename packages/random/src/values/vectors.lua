type VectorGenerator<T> = {
    unit: () -> T,
    ofLength: (length: number) -> T,
}

export type Vector2Generator = VectorGenerator<Vector2>
export type Vector3Generator = VectorGenerator<Vector3>

export type VectorsGenerator = {
    vector2: VectorGenerator<Vector2>,
    vector3: VectorGenerator<Vector3>,
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

    return {
        vector2 = {
            unit = vector2Unit,
            ofLength = vector2OfLength,
        },
        vector3 = {
            unit = vector3Unit,
            ofLength = vector3OfLength,
        },
    }
end

return createVectorGenerators
