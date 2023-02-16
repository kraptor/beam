import real
import rays
import points
import vectors
import matrices

import materials

import entities
import entities_impl


type
    Plane* = ref object of Entity


func plane*(transform: Matrix4 = Matrix4.identity, material: Material = material()): Plane =
    result = Plane(

    )
    result.init_entity(transform, material)


method local_intersect*(p: Plane, local_ray: Ray): IntersectionCollection =
    if local_ray.direction.y ~= 0:
        # the plane is in XZ, therefore, if the ray Y direction is ~= 0, then
        # there is no intersection against the plane as the ray is parallel to it
        return

    var t = -local_ray.origin.y / local_ray.direction.y
    result.add intersection(t, p)



method local_normal_at*(p: Plane, local_point: Point): Vector =
    const normal = vector(0, 1, 0)
    return normal