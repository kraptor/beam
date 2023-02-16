import ../colors
import ../matrices

import patterns

type
    RingPattern* = ref object of Pattern
        a*, b*: Color


func ring_pattern*(a, b: Color, transform: Matrix4 = Matrix4.identity): RingPattern =
    result = RingPattern(
        a: a,
        b: b,
    ) 
    result.init_pattern(transform)


func `~=`*(a, b: RingPattern): bool =
    Pattern(a) ~= Pattern(b) and (
        a.a ~= b.a and
        a.b ~= b.b
    )