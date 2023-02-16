import ../math
import ../colors
import ../points

import stripes


method pattern_at*(pattern: StripePattern, p: Point): Color =
    if floor(p.x) mod 2 == 0:
        return pattern.a
    return pattern.b