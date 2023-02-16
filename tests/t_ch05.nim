import unittest

import beam/api


suite "Chapter 5 tests":
    
    test "Creating and querying a ray":
        let
            origin = point(1, 2, 3)
            direction = vector(4, 5, 6)
            r = ray(origin, direction)
        
        check:
            r.origin ~= origin
            r.direction ~= direction

    test "Computing a point from a distance":
        let
            r = ray(point(2, 3, 4), vector(1, 0, 0))

        check:
            r.position(0) ~= point(2, 3, 4)
            r.position(1) ~= point(3, 3, 4)
            r.position(-1) ~= point(1, 3, 4)
            r.position(2.5) ~= point(4.5, 3, 4)

    test "A ray intersects a sphere at two points":
        let
            r = ray(point(0,0,-5), vector(0, 0, 1))
            s = sphere()
            xs = s.intersect(r)

        check:
            xs.len == 2
            xs[0].t  ~= 4.0
            xs[1].t  ~= 6.0

    test "A ray intersects a sphere at a tangent":
        let
            r = ray(point(0,1,-5), vector(0, 0, 1))
            s = sphere()
            xs = s.intersect(r)

        check:
            xs.len == 2
            xs[0].t  ~= 5.0
            xs[1].t  ~= 5.0

    test "A ray misses a sphere":
        let
            r = ray(point(0,2,-5), vector(0, 0, 1))
            s = sphere()
            xs = s.intersect(r)

        check:
            xs.len == 0

    test "A ray originates inside a sphere":
        let
            r = ray(point(0,0,0), vector(0, 0, 1))
            s = sphere()
            xs = s.intersect(r)

        check:
            xs.len == 2
            xs[0].t  ~= -1
            xs[1].t  ~= 1

    test "A sphere is behind a ray":
        let
            r = ray(point(0,0,5), vector(0, 0, 1))
            s = sphere()
            xs = s.intersect(r)

        check:
            xs.len == 2
            xs[0].t  ~= -6
            xs[1].t  ~= -4

    test "An intersection encapsulates t and object":
        let
            s = sphere()
            i = intersection(3.5, s)

        check:
            i.t ~= 3.5
            i.entity == s

    test "Aggregating intersections":
        let
            s = sphere()
            i1 = intersection(1, s)
            i2 = intersection(2, s)
            xs = intersections(i1, i2)

        check:
            xs.len == 2
            xs[0].t ~= 1
            xs[1].t ~= 2

    test "Intersect sets the object on the intersection":
        let
            r = ray(point(0,0,-5), vector(0,0,1))
            s = sphere()
            xs = s.intersect(r)

        check:
            xs.len == 2
            xs[0].entity == s
            xs[1].entity == s

    test "The hit, when all intersections have positive t":
        let
            s = sphere()
            i1 = intersection(1, s)
            i2 = intersection(2, s)
            xs = intersections(i2, i1)
            i = xs.hit()

        check: i == i1

    test "The hit, when some intersections have negative t":
        let
            s = sphere()
            i1 = intersection(-1, s)
            i2 = intersection(1, s)
            xs = intersections(i2, i1)
            i = xs.hit()

        check: i == i2

    test "The hit, when all intersections have negative t":
        let
            s = sphere()
            i1 = intersection(-2, s)
            i2 = intersection(-1, s)
            xs = intersections(i2, i1)
            i = xs.hit()

        check: i == nil

    test "The hit is always the lowest nonnegative intersection":
        let
            s = sphere()
            i1 = intersection(5, s)
            i2 = intersection(7, s)
            i3 = intersection(-3, s)
            i4 = intersection(2, s)
            xs = intersections(i1, i2, i3, i4)
            i = xs.hit()
        
        check: i == i4

    test "Translating a ray":
        let
            r = ray(point(1, 2, 3), vector(0, 1, 0))
            m = translation(3, 4, 5)
            r2 = r.transform(m)
            
        check:
            r2.origin ~= point(4, 6, 8)
            r2.direction ~= vector(0, 1, 0)

    test "Scaling a ray":
        let
            r = ray(point(1, 2, 3), vector(0, 1, 0))
            m = scaling(2, 3, 4)
            r2 = r.transform(m)

        check:
            r2.origin ~= point(2, 6, 12)
            r2.direction ~= vector(0, 3, 0)

    test "A sphere's default transformation":
        let
            s = sphere()
        
        check: s.transform ~= Matrix4.identity

    test "Changing a sphere's transformation":
        let t = translation(2, 3, 4)
        var s = sphere()
        var s2 = sphere(1, t)
            
        s.transform = t

        check: 
            s.transform ~= t
            s2.transform ~= t
    
    test "Intersecting a scaled sphere with a ray":
        let r = ray(point(0,0,-5), vector(0,0,1))
        var s = sphere()

        s.transform = scaling(2,2,2)

        let xs = s.intersect(r)

        check:
            xs.len == 2
            xs[0].t ~= 3
            xs[1].t ~= 7

    test "Intersecting a translated sphere with a ray":
        let r = ray(point(0,0,-5), vector(0,0,1))
        var s = sphere()

        s.transform = translation(5, 0, 0)

        let xs = s.intersect(r)

        check:
            xs.len == 0