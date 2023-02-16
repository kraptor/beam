import unittest
import math

import beam/api


suite "Chapter 7":
    test "Creating a world":
        let w = world()
        check: 
            w.entities.len == 0
            w.lights.len == 0

    test "The default world":
        let
            light = point_light(point(-10, 10, -10), color(1, 1, 1))
            s1 = sphere(
                material = material(
                    color = color(0.8, 1.0, 0.6),
                    diffuse = 0.7,
                    specular = 0.2,
                )
            )
            s2 = sphere(
                transform = scaling(0.5, 0.5, 0.5)
            )
        
        var w = default_world()

        check:
            w.lights[0] ~= light
            w.entities[0] ~= s1
            w.entities[1] ~= s2
    
    test "Intersect a world with a ray":
        let
            w = default_world()
            r = ray(point(0, 0, -5), vector(0, 0, 1))
            xs = w.intersect(r)

        check:
            xs.len == 4
            xs[0].t ~= 4
            xs[1].t ~= 4.5
            xs[2].t ~= 5.5
            xs[3].t ~= 6

    test "Precomputing the state of an intersection":
        let
            r = ray(point(0, 0, -5), vector(0, 0, 1))
            shape = sphere()
            i = intersection(4, shape)
            c = prepare_computations(i, r)

        check:
            c.intersection.t ~= i.t
            c.intersection.entity == i.entity
            c.point ~= point(0, 0, -1)
            c.eyev ~= vector(0, 0, -1)
            c.normalv ~= vector(0, 0, -1)

    test "The hit, when an intersection occurs on the outside":
        let
            r = ray(point(0, 0, -5), vector(0, 0, 1))
            shape = sphere()
            i = intersection(4, shape)
            c = prepare_computations(i, r)

        check:
            c.inside == false

    test "The hit, when an intersection occurs on the inside":
        let 
            r = ray(point(0, 0, 0), vector(0, 0, 1))
            shape = sphere()
            i = intersection(1, shape)
            c = prepare_computations(i, r)

        check:
            c.point ~= point(0, 0, 1)
            c.eyev ~= vector(0, 0, -1)
            c.inside == true
            # normal would have been (0, 0, 1), but is inverted!
            c.normalv ~= vector(0, 0, -1)

    test "Shading an intersection":
        let
            w = default_world()
            r = ray(point(0, 0, -5), vector(0, 0, 1))
            shape = w.entities[0]
            i = intersection(4, shape)
            comps = prepare_computations(i, r)
            c = shade_hit(w, comps)

        check: 
            c ~= color(0.38066, 0.47583, 0.2855)

    test "Shading an intersection from the inside":
        var
            w = default_world()
        
        w.lights[0] = point_light(point(0, 0.25, 0), color(1, 1, 1))
        
        let
            r = ray(point(0, 0, 0), vector(0, 0, 1))
            shape = w.entities[1]
            i = intersection(0.5, shape)
            comps = prepare_computations(i, r)
            c = shade_hit(w, comps)
        
        check:
            c ~= color(0.90498, 0.90498, 0.90498)

    test "The color when a ray misses":
        let
            w = default_world()
            r = ray(point(0, 0, -5), vector(0, 1, 0))
            c = color_at(w, r)

        check:
            c ~= color(0, 0, 0)

    test "The color when a ray hits":
        let
            w = default_world()
            r = ray(point(0, 0, -5), vector(0, 0, 1))
            c = color_at(w, r)

        check:
            c ~= color(0.38066, 0.47583, 0.2855)

    test "The color with an intersection behind the ray":
        let
            w = default_world()
            
        var 
            outer = w.entities[0]
            inner = w.entities[1]

        outer.material.ambient = 1
        inner.material.ambient = 1

        let
            r = ray(point(0, 0, 0.75), vector(0, 0, -1))
            c = color_at(w, r)

        check:
            c ~= inner.material.color

    test "The transformation matrix for the default orientation":
        let
            at = point(0, 0, 0)
            to = point(0, 0, -1)
            up = vector(0, 1, 0)
            t = view_transform(at, to, up)

        check:
            t ~= Matrix4.identity

    test "A view transformation matrix looking in positive z direction":
        let
            at = point(0, 0, 0)
            to = point(0, 0, 1)
            up = vector(0, 1, 0)
            t = view_transform(at, to, up)

        check:
            t ~= scaling(-1, 1, -1)

    test "The view transformation moves the world":
        let
            at = point(0, 0, 8)
            to = point(0, 0, 0)
            up = vector(0, 1, 0)
            t = view_transform(at, to, up)

        check:
            t ~= translation(0, 0, -8)

    test "An arbitrary view transformation":
        let
            at = point(1, 3, 2)
            to = point(4, -2, 8)
            up = vector(1, 1, 0)
            t = view_transform(at, to, up)

        check:
            t ~= matrix4([
                -0.50709, 0.50709,  0.67612, -2.36643,
                 0.76772, 0.60609,  0.12122, -2.82843,
                -0.35857, 0.59761, -0.71714,  0.00000,
                 0.00000, 0.00000,  0.00000,  1.00000,
            ])

    test "Constructing a camera":
        let
            hsize = 160
            vsize = 120
            fov = PI / 2
            c = camera(hsize, vsize, fov)

        check:
            c.hsize == 160
            c.vsize == 120
            c.fov ~= PI / 2
            c.transform ~= Matrix4.identity

    test "The pixel size for a horizontal canvas":
        let
            c = camera(200, 125, PI/2)
    
        check: c.pixel_size ~= 0.01

    test "The pixel size for a vertical canvas":
        let
            c = camera(125, 200, PI/2)
    
        check: c.pixel_size ~= 0.01

    test "Constructing a ray through the center of the canvas":
        let
            c = camera(201, 101, PI/2)
            r = c.ray_for_pixel(100, 50)

        check:
            r.origin ~= point(0, 0, 0)
            r.direction ~= vector(0, 0, -1)

    test "Constructing a ray through a corner of the canvas":
        let
            c = camera(201, 101, PI/2)
            r = ray_for_pixel(c, 0, 0)
        
        check:
            r.origin ~= point(0, 0, 0)
            r.direction ~= vector(0.66519, 0.33259, -0.66851)

    test "Constructing a ray when the camera is transformed":
        var 
            c = camera(201, 101, PI/2)
            
        c.transform = rotation_y(PI/4) * translation(0, -2, 5)

        let r = ray_for_pixel(c, 100, 50)

        check:
            r.origin ~= point(0, 2, -5)
            r.direction ~= vector(sqrt(2.0)/2, 0, -sqrt(2.0)/2)

    test "Rendering a world with a camera":
        let
            w = default_world()
            at = point(0, 0, -5)
            to = point(0, 0, 0)
            up = vector(0, 1, 0)

        var c = camera(11, 11, PI/2)

        c.transform = view_transform(at, to, up)

        let image = c.render(w)

        check:
            image.get_color(5, 5) ~= color(0.38066, 0.47583, 0.2855)