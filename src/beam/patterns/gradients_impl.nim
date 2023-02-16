import ../math
import ../colors
import ../points

import gradients


method pattern_at*(pattern: GradientPattern, p: Point): Color =
    pattern.a + (pattern.b - pattern.a) * (p.x - floor(p.x))