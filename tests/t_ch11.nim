import unittest

import math
import beam/api


suite "Chapter 11":
    test "Reflectivity for the default material":
        var m = material()
        check m.reflective ~= 0.0

    test "Precomputing the reflection vector":
        let 
            shape = plane()
            r = ray(point(0, 1, -1), vector(0, -sqrt(2.0)/2, sqrt(2.0)/2))
            i = intersection(sqrt(2.0), shape)
            comps = prepare_computations(i, r)
        
        check: comps.reflectv ~= vector(0, sqrt(2.0)/2, sqrt(2.0)/2)

    test "The reflected color for a nonreflective material":
        let
            w = default_world()
            r = ray(point(0, 0, 0), vector(0, 0, 1))

        var shape = w.entities[1]
        shape.material.ambient = 1

        let 
            i = intersection(1, shape)
            comps = prepare_computations(i, r)
            color = reflected_color(w, comps)
        
        check color ~= color(0, 0, 0)


    test "The reflected color for a reflective material":
        var 
            w = default_world()
            shape = plane(
                material = material(reflective=0.5),
                transform = translation(0, -1, 0)
            )

        w.entities.add(shape)
        
        let
            r = ray(point(0, 0, -3), vector(0, -sqrt(2.0)/2.0, sqrt(2.0)/2.0))
            i = intersection(sqrt(2.0), shape)
            comps = prepare_computations(i, r)
            color = reflected_color(w, comps)
        
        check color ~= color(0.19033, 0.23791, 0.14274)

    test "shade_hit() with a reflective material":
        var 
            w = default_world()
            shape = plane(
                material = material(reflective = 0.5),
                transform = translation(0, -1, 0)
            )
    
        w.entities.add(shape)

        let
            r = ray(point(0, 0, -3), vector(0, -sqrt(2.0)/2, sqrt(2.0)/2))
            i = intersection(sqrt(2.0), shape)
            comps = prepare_computations(i, r)
            color = shade_hit(w, comps)

        check: color ~= color(0.87677, 0.92436, 0.82918)

    test "color_at() with mutually reflective surfaces":
        let
            lower = plane(
                material = material(reflective=1),
                transform = translation(0, -1, 0),
            )

            upper = plane(
                material = material(reflective=1),
                transform = translation(0, 1, 0),
            )

        var w = world(
            lights = @[ point_light(point(0, 0, 0), color(1, 1, 1)) ],
            entities = @[lower.Entity, upper],
        )

        let r = ray(point(0, 0, 0), vector(0, 1, 0))

        # this shold get to the max call depth limit
        discard color_at(w, r)
    
    test "The reflected color at the maximum recursive depth":
        var 
            w = default_world()
            shape = plane(
                material = material(reflective=0.5),
                transform = translation(0, -1, 0),
            )
        
        w.entities.add(shape)
        
        let
            r = ray(point(0, 0, -3), vector(0, -sqrt(2.0)/2, sqrt(2.0)/2))
            i = intersection(sqrt(2.0), shape)
            comps = prepare_computations(i, r)
            color = reflected_color(w, comps, 0)
        
        check: color ~= color(0, 0, 0)