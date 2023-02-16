import ../colors
import ../matrices
import patterns

type
    CheckerPattern* = ref object of Pattern
        a*, b*: Color


func checkers_pattern*(a, b: Color, transform: Matrix4 = Matrix4.identity): CheckerPattern =
    result = CheckerPattern(
        a: a,
        b: b,
    ) 
    result.init_pattern(transform)


func `~=`*(a, b: CheckerPattern): bool =
    Pattern(a) ~= Pattern(b) and (
        a.a ~= b.a and
        a.b ~= b.b
    )