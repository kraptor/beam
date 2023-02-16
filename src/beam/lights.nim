import points
import colors

type
    PointLight* = object
        position*: Point
        intensity*: Color

    Light* = PointLight

proc `~=`*(a, b: PointLight): bool =
    a.position ~= b.position and
    a.intensity ~= b.intensity

proc point_light*(position: Point, intensity: Color): PointLight =
    PointLight(
        position: position,
        intensity: intensity
    )