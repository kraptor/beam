import strformat

import real

type 
    Tuple* = object
        x*: Real
        y*: Real
        z*: Real
        w*: Real

func init*(t: typedesc[Tuple], x, y, z, w: Real): Tuple =
    result.x = x
    result.y = y
    result.z = z
    result.w = w

func `$`*(a: Tuple): string =
    fmt"({a.x}, {a.y}, {a.z}, {a.w})"

func `~=`*(a, b: Tuple): bool =
    a.x ~= b.x and
    a.y ~= b.y and
    a.z ~= b.z and
    a.w ~= b.w

func `+`*(a, b: Tuple): Tuple =
    result.x = a.x + b.x
    result.y = a.y + b.y
    result.z = a.z + b.z
    result.w = a.w + b.w

func `-`*(a, b: Tuple): Tuple =
    result.x = a.x - b.x
    result.y = a.y - b.y
    result.z = a.z - b.z
    result.w = a.w - b.w

func `-`*(a: Tuple): Tuple =
    result.x = -a.x
    result.y = -a.y
    result.z = -a.z
    result.w = -a.w

func `*`*(a: Tuple, b: Real): Tuple =
    result.x = a.x * b
    result.y = a.y * b
    result.z = a.z * b
    result.w = a.w * b

template `*`*(a: Real, b: Tuple): Tuple = b * a

func `/`*(a: Tuple, b: Real): Tuple =
    result.x = a.x / b
    result.y = a.y / b
    result.z = a.z / b
    result.w = a.w / b

func `/`*(a: Real, b: Tuple) {.error: "Cannot divide an scalar by a tuple".}