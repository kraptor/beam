import ../matrices


type 
    Pattern* = ref object of RootObj
        p_transform: Matrix4
        p_transform_inverse_memoed: bool
        p_transform_inverse: Matrix4


func init_pattern*(pattern: Pattern, transform: Matrix4 = Matrix4.identity) =
    pattern.p_transform = transform
    pattern.p_transform_inverse = transform.inverse()
    pattern.p_transform_inverse_memoed = true


func `~=`*(a, b: Pattern): bool =
    a == b or (
        a.p_transform == b.p_transform
    )

method transform*(pattern: Pattern): Matrix4 {.base.} = 
    pattern.p_transform

method `transform=`*(pattern: Pattern, v: Matrix4) {.base.} =
    pattern.p_transform = v
    pattern.p_transform_inverse_memoed = false

method transform_inverse*(pattern: Pattern): Matrix4 {.base.} =
    if not pattern.p_transform_inverse_memoed:
        pattern.p_transform_inverse = pattern.p_transform.inverse
        pattern.p_transform_inverse_memoed = true
    pattern.p_transform_inverse