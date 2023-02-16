import real
import rays
import points
import vectors
import colors
import worlds

import entities

import entities_impl
import materials_impl

type
    Computation = object
        intersection*: Intersection
        point*: Point
        over_point*: Point
        eyev*: Vector
        normalv*: Vector
        inside*: bool
        reflectv*: Vector


func prepare_computations*(intersection: Intersection, ray: Ray): Computation =
    let
        point = position(ray, intersection.t)
        eyev = -ray.direction

    var
        normalv = intersection.entity.normal_at(point)
        inside = false

    if normalv.dot(eyev) < 0:
        inside = true
        normalv = -normalv

    # adjust intersection point in the direction of the normal (used for shadowing)
    let
        over_point = point + normalv * EPSILON
        reflectv = reflect(ray.direction, normalv)

    Computation(
        intersection: intersection,
        point: point,
        over_point: over_point,
        eyev: eyev,
        normalv: normalv,
        inside: inside,
        reflectv: reflectv
    )

const MAX_RAY_BOUNCES = 5

func shade_hit*(w: World, c: Computation, remaining: int = MAX_RAY_BOUNCES): Color # forward declaration


func color_at*(w: World, r: Ray, remaining: int = MAX_RAY_BOUNCES): Color =
    for intersection in w.intersect(r):
        if intersection.t >= 0:
            return shade_hit(w, prepare_computations(intersection, r), remaining)


func reflected_color*(w: World, comps: Computation, remaining: int = MAX_RAY_BOUNCES): Color =
    if remaining <= 0:
        return Color.BLACK

    if comps.intersection.entity.material.reflective ~= 0.0:
        return Color.BLACK

    let
        reflect_ray = ray(comps.over_point, comps.reflectv)
        color = color_at(w, reflect_ray, remaining)

    return color * comps.intersection.entity.material.reflective


func shade_hit*(w: World, c: Computation, remaining: int = MAX_RAY_BOUNCES): Color =
    result = color(0, 0, 0)
    for light in w.lights:
        let
            shadowed = w.is_shadowed(c.over_point)
            surface = lighting(
                c.intersection.entity.material,
                c.intersection.entity,
                light,
                c.point,
                c.eyev,
                c.normalv,
                shadowed
            )
            reflected = reflected_color(w, c, remaining - 1)

        result = result + surface + reflected

    # result = result.normalize()





