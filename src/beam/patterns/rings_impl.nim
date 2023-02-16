import ../math
import ../colors
import ../points

import rings


method pattern_at*(pattern: RingPattern, p: Point): Color =
    if floor(sqrt(p.x * p.x + p.z * p.z)) mod 2 == 0:
        result = pattern.a
    else:
        result = pattern.b