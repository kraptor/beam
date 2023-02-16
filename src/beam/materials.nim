import real
import colors

import patterns/patterns


type
    PhongMaterial* = object
        color*: Color
        ambient*: Real
        diffuse*: Real
        specular*: Real
        shininess*: Real
        pattern*: Pattern
        reflective*: Real
        
    Material* = PhongMaterial


func `~=`*(a, b: Material): bool =
    a == b or (
        a.color ~= b.color and
        a.ambient ~= b.ambient and
        a.diffuse ~= b.diffuse and
        a.specular ~= b.specular and
        a.shininess ~= b.shininess and
        a.pattern ~= b.pattern and
        a.reflective ~= b.reflective
    )


func material*(
    color: Color = color(1, 1, 1), 
    ambient: Real = 0.1, 
    diffuse: Real = 0.9, 
    specular: Real = 0.9, 
    shininess: Real = 200.0,
    pattern: Pattern = nil,
    reflective: Real = 0.0
): Material =
    Material(
        color: color,
        ambient: ambient,
        diffuse: diffuse,
        specular: specular,
        shininess: shininess,
        pattern: pattern,
        reflective: reflective
    )