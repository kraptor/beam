import algorithm

import lights
import spheres
import matrices
import points
import colors
import rays
import vectors
import materials

import entities
import entities_impl


type 
    World* = object
        entities*: seq[Entity]
        lights*: seq[Light]


func world*(lights: seq[Light] = @[], entities: seq[Entity] = @[]): World =
    World(
        entities: entities,
        lights: lights
    )


func default_world*: World =
    let
        ligths = @[point_light(point(-10, 10, -10), color(1, 1, 1))]
        entities = @[
            Entity sphere(
                material = material(
                    color = color(0.8, 1.0, 0.6),
                    diffuse = 0.7,
                    specular = 0.2,
                )
            ),
            sphere(
                transform = scaling(0.5, 0.5, 0.5)
            )
        ]

    world(ligths, entities)


func intersect*(w: World, r: Ray): IntersectionCollection =
    for e in w.entities:
        for hit in e.intersect(r):
            result.add hit

    # requires the `<` operator on Intersection
    sort(result)


func is_shadowed*(w: World, point: Point): bool =

    result = false

    for light in w.lights:
        let
            v = light.position - point
            distance = v.magnitude # distance to light
            direction = v.normalize # direction to light

            r = ray(point, direction) # ray to light
            intersections = w.intersect(r)
            h = hit(intersections)

        # if we hit anything between the light and the point, it
        # means the point is behind another entity and, therefore,
        # it is shadowed
        if h != nil and h.t < distance:
            return true