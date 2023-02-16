import ../math
import ../colors
import ../points

import checkers


method pattern_at*(pattern: CheckerPattern, p: Point): Color =
    if (floor(p.x) + floor(p.y) + floor(p.z)) mod 2 == 0:
        result = pattern.a
    else:
        result = pattern.b