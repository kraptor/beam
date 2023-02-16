import strformat

import real
import tuples
import vectors

type
    Point* {.borrow: `.`.} = distinct Tuple

func point*(x, y, z: Real): Point = 
    result.x = x
    result.y = y
    result.z = z
    result.w = 1.0

func `$`*(c: Point): string =
    fmt("Point({c.x},{c.y},{c.z},{c.w})")

const ZERO_POINT = point(0,0,0)

func ORIGIN*(t: typedesc[Point]): Point = ZERO_POINT
func ZERO*(t: typedesc[Point]): Point = ZERO_POINT

func `~=`*(a: Point, b: Point): bool = Tuple(a) ~= Tuple(b)
func `~=`*(a: Point, b: Tuple): bool = Tuple(a) ~= b

func `-`*(a: Point , b: Point ): Vector = Vector(Tuple(a) - Tuple(b))
func `-`*(a: Point , v: Vector): Point  = Point(Tuple(a) - Tuple(v))
func `+`*(a: Point , v: Vector): Point  = Point(Tuple(a) + Tuple(v))
func `-`*(a: Vector, v: Point ): Point {.error: "A point cannot be substracted from a vector".}