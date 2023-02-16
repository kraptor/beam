import strformat

import real

type
    RgbColor* = object
        r*, g*, b*: Real

    Color* = RgbColor

func color*(r, g, b: Real = 1.0): RgbColor = 
    result.r = r
    result.g = g
    result.b = b

func BLACK*(t: typedesc[Color]): Color =
    return color(0, 0, 0)

func WHITE*(t: typedesc[Color]): Color =
    return color(1, 1, 1)

func `$`*(c: RgbColor): string =
    fmt("Color({c.r},{c.g},{c.b})")


func `~=`*(c1, c2: RgbColor): bool = 
    c1.r ~= c2.r and
    c1.g ~= c2.g and
    c1.b ~= c2.b 


# func `~=`*(a: Point, b: Tuple): bool = Tuple(a) ~= b

# func `-`*(a: Point , b: Point ): Vector = Vector(Tuple(a) - Tuple(b))
# func `-`*(a: Point , v: Vector): Point  = Point(Tuple(a) - Tuple(v))
# func `-`*(a: Vector, v: Point ): Point {.error: "A point cannot be substracted from a vector".}

func `+`*(c1, c2: RgbColor): RgbColor =
    # FIXME: this is a linear add, not physically correct
    result.r = c1.r + c2.r
    result.g = c1.g + c2.g
    result.b = c1.b + c2.b

func `-`*(c1, c2: RgbColor): RgbColor =
    # FIXME: this is a linear sub, not physically correct
    result.r = c1.r - c2.r
    result.g = c1.g - c2.g
    result.b = c1.b - c2.b

func `*`*(c: RgbColor, v: Real): RgbColor =
    # FIXME: this is a linear multiply, not physically correct
    result.r = c.r * v
    result.g = c.g * v
    result.b = c.b * v

template `*`*(v: Real, c: RgbColor): RgbColor = c * v

func `*`*(c1, c2: RgbColor): RgbColor =
    # FIXME: this is a linear multiply, not physically correct
    result.r = c1.r * c2.r
    result.g = c1.g * c2.g
    result.b = c1.b * c2.b

func normalize*(c: RgbColor): RgbColor =
    var max_value = max([c.r, c.g, c.b])
    result = color(c.r/max_value, c.g/max_value, c.b/max_value)