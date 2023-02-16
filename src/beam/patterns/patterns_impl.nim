import ../colors
import ../points
import ../matrices
import ../entities

import patterns


method pattern_at*(pattern: Pattern, p: Point): Color {.base.} =
    raise newException(Exception, "Not implemented " & $type(pattern) &  ".pattern_at().")


func pattern_at_entity*(pattern: Pattern, entity: Entity, world_point: Point): Color =
    let 
        entity_point = entity.transform_inverse * world_point
        pattern_point = pattern.transform_inverse * entity_point
    return pattern.pattern_at(pattern_point)


