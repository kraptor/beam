import math

import real
import rays
import points
import vectors
import matrices

import entities
import entities_impl

import materials


type
    Sphere* = ref object of Entity
        radius: Real

func `~=`*(a: Sphere, b: Sphere): bool =
    a == b or (
        Entity(a) ~= Entity(b) and
        a.radius == b.radius
    )


func sphere*(radius: Real = 1, transform: Matrix4 = Matrix4.identity, material: Material = material()): Sphere =
    result = Sphere(
        radius: radius
    )
    result.init_entity(transform, material)


method local_intersect(s: Sphere, local_ray: Ray): IntersectionCollection =
    let
        sr = local_ray.origin - Point.ORIGIN
        a = local_ray.direction.dot(local_ray.direction)
        b = 2 * local_ray.direction.dot(sr)
        c = sr.dot(sr) - 1
        discriminant = b * b - 4 * a * c

    if discriminant < 0:
        return result

    let 
        a2 = 2*a
        discriminant_squared = sqrt(discriminant)
    
    return intersections(
        intersection( (-b - discriminant_squared) / a2, s),
        intersection( (-b + discriminant_squared) / a2, s)
    )


method local_normal_at*(s: Sphere, local_point: Point): Vector =
    let
        normal = local_point - Point.ORIGIN
    normal.normalize()
