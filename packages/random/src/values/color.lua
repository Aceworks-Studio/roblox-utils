export type ColorGenerator = {
    saturated: (saturation: number?) -> Color3,
    brightness: (hue: number, saturation: number?) -> Color3,
    spreadHue: (color: Color3, hueSpan: number) -> Color3,
    gray: () -> Color3,
    black: (chance: number?) -> Color3,
    white: (chance: number?) -> Color3,
}

local function createColorGenerator(random: Random): ColorGenerator
    local function saturated(saturation: number?, value: number?): Color3
        local hue = random:NextNumber()

        return Color3.fromHSV(hue, saturation or 1, value or 1)
    end

    local function brightness(hue: number, saturation: number?): Color3
        local value = random:NextNumber()

        return Color3.fromHSV(hue, saturation or 1, value)
    end

    local function spreadHue(color: Color3, hueSpan: number): Color3
        local hue, saturation, value = color:ToHSV()

        local newHue = hue + hueSpan * (random:NextNumber() - 0.5)

        return Color3.fromHSV(newHue % 1, saturation, value)
    end

    local function gray(): Color3
        local level = random:NextNumber()
        return Color3.new(level, level, level)
    end

    local BLACK = Color3.new(0, 0, 0)
    local WHITE = Color3.new(1, 1, 1)

    local function black(chance: number?, fallback: Color3?): Color3
        return if random:NextNumber() >= (chance or 0.5) then BLACK else (fallback or WHITE)
    end

    local function white(chance: number?, fallback: Color3?): Color3
        return if random:NextNumber() >= (chance or 0.5) then WHITE else (fallback or BLACK)
    end

    return {
        saturated = saturated,
        brightness = brightness,
        spreadHue = spreadHue,
        gray = gray,
        black = black,
        white = white,
    }
end

return createColorGenerator
