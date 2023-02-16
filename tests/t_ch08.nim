import unittest

import beam/api


suite "Chapter 8":
    setup:
        var 
            m = material()
            position = Point.ZERO

    test "Lighting with the surface in shadow":
        let
            entity = sphere()
            eyev = vector(0, 0, -1)
            normalv = vector(0, 0, -1)
            light = point_light(point(0,0,-10), color(1, 1, 1))
            in_shadow = true
            result = lighting(m, entity, light, position, eyev, normalv, in_shadow)

        check:
            result ~= color(0.1, 0.1, 0.1)

    test "There is no shadow when nothing is collinear with point and light":
        let
            w = default_world()
            p = point(0, 10, 0)
            
        check: w.is_shadowed(p) == false

    test "The shadow when an object is between the point and the light":
        let
            w = default_world()
            p = point(10, -10, 10)
            
        check: w.is_shadowed(p) == true

    test "There is no shadow when an object is behind the light":
        let
            w = default_world()
            p = point(-20, 20, -20)
            
        check: w.is_shadowed(p) == false

    test "There is no shadow when an object is behind the point":
        let
            w = default_world()
            p = point(-2, 2, -2)
            
        check: w.is_shadowed(p) == false

    test "shade_hit() is given an intersection in shadow":
        var w = world()
        w.lights.add point_light(point(0, 0, -10), color(1, 1, 1))

        let s1 = sphere()
        w.entities.add s1
        
        let s2 = sphere().translate(0, 0, 10)
        w.entities.add s2
        
        let 
            r = ray(point(0, 0, 5), vector(0, 0, 1))
            i = intersection(4, s2)
            comps = prepare_computations(i, r)
            c = shade_hit(w, comps)
        
        check: c ~= color(0.1, 0.1, 0.1)

    test "The hit should offset the point":
        let
            r = ray(point(0, 0, -5), vector(0, 0, 1))
            shape = sphere().translate(0, 0, 1)
            i = intersection(5, shape)
            comps = prepare_computations(i, r)

        check:
            comps.over_point.z < -EPSILON/2
            comps.point.z > comps.over_point.z