import real
import matrices
import materials


type
    Intersection* = ref object
        t*: Real
        entity*: Entity

    IntersectionCollection* = seq[Intersection]

    Entity* = ref object of RootObj
        p_transform: Matrix4
        p_transform_inverse_memoed: bool
        p_transform_inverse: Matrix4
        
        material*: Material


func `~=`*(a, b: Entity): bool =
    a.p_transform ~= b.p_transform and
        a.material ~= b.material


func init_entity*(e: Entity, transform: Matrix4 = Matrix4.identity, material: Material = material()) =
    e.material = material
    e.p_transform = transform
    e.p_transform_inverse = transform.inverse()
    e.p_transform_inverse_memoed = true

method transform*(e: Entity): Matrix4 {.base.} = e.p_transform
method `transform=`*(e: Entity, v: Matrix4) {.base.} =
    e.p_transform = v
    e.p_transform_inverse_memoed = false

method transform_inverse*(e: Entity): Matrix4 {.base.} =
    if not e.p_transform_inverse_memoed:
        e.p_transform_inverse = e.p_transform.inverse
        e.p_transform_inverse_memoed = true
    e.p_transform_inverse