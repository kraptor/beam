import ../colors
import ../matrices

import patterns

type
    GradientPattern* = ref object of Pattern
        a*, b*: Color


func gradient_pattern*(a, b: Color, transform: Matrix4 = Matrix4.identity): GradientPattern =
    result = GradientPattern(
        a: a,
        b: b,
    ) 
    result.init_pattern(transform)


func `~=`*(a, b: GradientPattern): bool =
    Pattern(a) ~= Pattern(b) and (
        a.a ~= b.a and
        a.b ~= b.b
    )