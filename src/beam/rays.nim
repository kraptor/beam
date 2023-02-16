import real
import points
import vectors
import matrices

type
    Ray* = object
        origin*: Point
        direction*: Vector


func ray*(origin: Point, direction: Vector): Ray =
    Ray(
        origin: origin,
        direction: direction
    )

func position*(r: Ray, t: Real): Point =
    r.origin + r.direction * t

func transform*(r: Ray, m: Matrix4): Ray =
    Ray(
        origin: m * r.origin,
        direction: m * r.direction,
    )