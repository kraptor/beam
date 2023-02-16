import ../colors
import ../matrices

import patterns

type
    StripePattern* = ref object of Pattern
        a*, b*: Color


func stripe_pattern*(a, b: Color, transform: Matrix4 = Matrix4.identity): StripePattern =
    result = StripePattern(
        a: a,
        b: b,
    ) 
    result.init_pattern(transform)


func `~=`*(a, b: StripePattern): bool =
    Pattern(a) ~= Pattern(b) and (
        a.a ~= b.a and
        a.b ~= b.b
    )