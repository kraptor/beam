import math
import strformat

import real
import tuples

type
    Vector* {.borrow: `.`.} = distinct Tuple

func vector*(x, y, z: Real): Vector = 
    result.x = x
    result.y = y
    result.z = z
    # result.w = 0.0 # nim zero-initializes memory

template vector(): Vector =
    vector(0, 0, 0)

const 
    ZERO_VECTOR = vector()

func ZERO*(t: typedesc[Vector]): Vector {.inline.} = ZERO_VECTOR

func `$`*(c: Vector): string =
    fmt("Vector({c.x},{c.y},{c.z},{c.w})")

func `~=`*(a: Vector, b: Vector): bool = Tuple(a) ~= Tuple(b)
func `~=`*(a: Vector, b: Tuple ): bool = Tuple(a) ~= b

func `-`*(a: Vector): Vector = Vector(-Tuple(a))
func `-`*(a: Vector, b: Vector): Vector = Vector(Tuple(a) - Tuple(b))
func `+`*(a: Vector, b: Vector): Vector = Vector(Tuple(a) + Tuple(b))
func `*`*(a: Vector, r: Real): Vector = Vector(Tuple(a) * r)

func magnitude_squared*(v: Vector): Real {.inline.} = 
    v.x * v.x + v.y * v.y + v.z * v.z 

func magnitude*(v: Vector): Real {.inline.} =
    sqrt magnitude_squared(v)

func normalize*(v: Vector): Vector =
    Vector(Tuple(v) / v.magnitude)

func dot*(a, b: Vector): Real =
    a.x * b.x +
    a.y * b.y +
    a.z * b.z

func cross*(a, b: Vector): Vector =
    vector(
        a.y * b.z - a.z * b.y,
        a.z * b.x - a.x * b.z,
        a.x * b.y - a.y * b.x
    )

func reflect*(a, normal: Vector): Vector =
    a - normal * 2 * a.dot(normal)