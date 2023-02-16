import unittest
import math

import beam/api


suite "Chapter 6 tests":
    test "The normal on a sphere at a point on the x axis":
        let 
            s = sphere()
            n = normal_at(s, point(1, 0, 0))
        check: n ~= vector(1, 0, 0)

    test "The normal on a sphere at a point on the y axis":
        let 
            s = sphere()
            n = normal_at(s, point(0, 1, 0))
        check: n ~= vector(0, 1, 0)

    test "The normal on a sphere at a point on the z axis":
        let 
            s = sphere()
            n = normal_at(s, point(0, 0, 1))
        check: n ~= vector(0, 0, 1)

    test "The normal on a sphere at a nonaxial point":
        let 
            s = sphere()
            n = normal_at(s, point(sqrt(3.0)/3, sqrt(3.0)/3, sqrt(3.0)/3))
        check: n ~= vector(sqrt(3.0)/3, sqrt(3.0)/3, sqrt(3.0)/3)

    test "The normal is a normalized vector":
        let
            s = sphere()
            n = normal_at(s, point(sqrt(3.0)/3, sqrt(3.0)/3, sqrt(3.0)/3))
        check: n ~= normalize(n)

    test "Computing the normal on a translated sphere":
        var s = sphere()
        s.transform = translation(0, 1, 0)

        let n = s.normal_at(point(0, 1.70711, -0.70711))

        check: n ~= vector(0, 0.70711, -0.70711)

    test "Computing the normal on a transformed sphere":
        var s = sphere()
        let m = scaling(1, 0.5, 1) * rotation_z(PI/5)

        s.transform = m

        let n = normal_at(s, point(0, sqrt(2.0)/2, -sqrt(2.0)/2))

        check: n ~= vector(0, 0.97014, -0.24254)

    test "Reflecting a vector approaching at 45 degrees":
        let 
            v = vector(1, -1, 0)
            n = vector(0, 1, 0)
            r = v.reflect(n)

        check: r ~= vector(1, 1, 0)

    test "Reflecting a vector off a slanted surface":
        let
            v = vector(0, -1, 0)
            n = vector(sqrt(2.0)/2, sqrt(2.0)/2, 0)
            r = reflect(v, n)

        check: r ~= vector(1, 0, 0)

    test "A point light has a position and intensity":
        let
            intensity = color(1, 1, 1)
            position = point(0, 0, 0)
            light = point_light(position, intensity)
        check:
            light.position ~= position
            light.intensity ~= intensity

    test "The default material":
        let
            m = material()
        
        check:
            m.color ~= color(1, 1, 1)
            m.ambient ~= 0.1
            m.diffuse ~= 0.9
            m.specular ~= 0.9
            m.shininess ~= 200.0

    test "A sphere has a default material":
        let 
            s = sphere()
            m = s.material
        
        check: m == material()

    test "A sphere may be assigned a material":
        var
            s = sphere()
            m = material()

        m.ambient = 1
        s.material = m

        check: 
            s.material.ambient ~= 1
            s.material == m

suite "Chapter 6 tests with setup":
    setup:
        var 
            m = material()
            position = Point.ZERO

    test "Lighting with the eye between the light and the surface":
        let
            entity = sphere()
            eyev = vector(0, 0, -1)
            normalv = vector(0, 0, -1)
            light = point_light(point(0, 0, -10), color(1, 1, 1))
            result = m.lighting(entity, light, position, eyev, normalv)
        
        check: result ~= color(1.9, 1.9, 1.9)

    test "Lighting with the eye between light and surface, eye offset 45°":
        let
            entity = sphere()
            eyev = vector(0, sqrt(2.0)/2, -sqrt(2.0)/2)
            normalv = vector(0, 0, -1)
            light = point_light(point(0, 0, -10), color(1, 1, 1))
            result = m.lighting(entity, light, position, eyev, normalv)
        
        check: result ~= color(1.0, 1.0, 1.0)

    test "Lighting with eye opposite surface, light offset 45°":
        let
            entity = sphere()
            eyev = vector(0, 0, -1)
            normalv = vector(0, 0, -1)
            light = point_light(point(0, 10, -10), color(1, 1, 1))
            result = m.lighting(entity, light, position, eyev, normalv)

        check: result ~= color(0.7364, 0.7364, 0.7364)

    test "Lighting with eye in the path of the reflection vector":
        let
            entity = sphere()
            eyev = vector(0, -sqrt(2.0)/2, -sqrt(2.0)/2)
            normalv = vector(0, 0, -1)
            light = point_light(point(0, 10, -10), color(1, 1, 1))
            result = m.lighting(entity, light, position, eyev, normalv)
        
        check: result ~= color(1.6364, 1.6364, 1.6364)

    test "Lighting with the light behind the surface":
        let
            entity = sphere()
            eyev = vector(0, 0, -1)
            normalv = vector(0, 0, -1)
            light = point_light(point(0, 0, 10), color(1, 1, 1))
            result = m.lighting(entity, light, position, eyev, normalv)

        check: result ~= color(0.1, 0.1, 0.1)