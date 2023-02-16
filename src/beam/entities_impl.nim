import real
import vectors
import matrices
import rays
import points


import entities; export entities


func intersection*(t: Real, entity: Entity): Intersection =
    Intersection(
        t: t,
        entity: entity
    )

func intersections*(all_intersections: varargs[Intersection]): IntersectionCollection =
    result.add(all_intersections)

func `<`*(a, b: Intersection): bool =
    a.t < b.t

func hit*(xs: IntersectionCollection): Intersection =
    result = intersection(Real.high, nil)
    
    for x in xs:
        if x.t > 0 and x.t < result.t:
            result = x

    if result.entity == nil:
        result = nil




method local_intersect(e: Entity, r: Ray): IntersectionCollection {.base.} =
    raise newException(Exception, "Not implemented " & $type(e) &  ".local_intersect().")

method intersect*(e: Entity, r: Ray): IntersectionCollection {.base.} =
    let local_ray = r.transform(e.transform_inverse)
    return local_intersect(e, local_ray)

method local_normal_at(e: Entity, local_space_point: Point): Vector {.base.} =
    raise newException(Exception, "Not implemented " & $type(e) &  ".local_normal_at().")

method normal_at*(e: Entity, world_space_point: Point): Vector {.base.} =
    let 
        local_point = e.transform_inverse * world_space_point
        local_normal = local_normal_at(e, local_point)
        
    var world_normal = transpose(inverse(e.transform)) * local_normal

    world_normal.w = 0

    return world_normal.normalize()
        

method translate*(e: Entity, x, y, z: Real): Entity {.base, discardable.} =
    `transform=`(e, e.transform * translation(x, y, z))
    return e

method scale*(e: Entity, x, y, z: Real): Entity {.base, discardable.} =
    `transform=`(e, e.transform * scaling(x, y, z))
    return e

method shear*(e: Entity, xy, xz, yx, yz, zx, zy: Real): Entity {.base, discardable.} =
    `transform=`(e, e.transform * shearing(xy, xz, yx, yz, zx, zy))
    return e

method rotate_x*(e: Entity, radians: Real): Entity {.base, discardable.} =
    `transform=`(e, e.transform * rotation_x(radians))
    return e

method rotate_y*(e: Entity, radians: Real): Entity {.base, discardable.} =
    `transform=`(e, e.transform * rotation_y(radians))
    return e

method rotate_z*(e: Entity, radians: Real): Entity {.base, discardable.} =
    `transform=`(e, e.transform * rotation_z(radians))
    return e



