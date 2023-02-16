import unittest
import math

import beam/api


type TestShape = ref object of Entity
    saved_ray: Ray


func test_shape(): TestShape =
    result = TestShape(
        saved_ray: ray(point(0,0,0), vector(0,0,0))
    )
    result.init_entity()

method local_intersect(t: TestShape, local_ray: Ray): IntersectionCollection =
    t.saved_ray = local_ray
    result = @[]

method local_normal_at(t: TestShape, local_space_point: Point): Vector =
    vector(local_space_point.x, local_space_point.y, local_space_point.z)


suite "Chapter 9":
    test "The default transformation":
        let s = test_shape()
        check s.transform ~= Matrix4.identity

    test "Assigning a transformation":
        var s = test_shape()
        s.translate(2, 3, 4)

        check: s.transform ~= translation(2, 3, 4)

    test "The default material":
        let 
            s = test_shape()
            m = s.material
        
        check: m ~= material()

    test "Intersecting a scaled shape with a ray":
        var s = test_shape()
        s.scale(2, 2, 2)
        
        let 
            r = ray(point(0, 0, -5), vector(0, 0, 1))
            xs = s.intersect(r)

        check:
            s.saved_ray.origin ~= point(0, 0, -2.5)
            s.saved_ray.direction ~= vector(0, 0, 0.5)

    test "Intersecting a translated shape with a ray":
        var s = test_shape()
        s.translate(5, 0, 0)

        let 
            r = ray(point(0, 0, -5), vector(0, 0, 1))
            xs = intersect(s, r)

        check:
            s.saved_ray.origin ~= point(-5, 0, -5)
            s.saved_ray.direction ~= vector(0, 0, 1)
    
    test "Computing the normal on a translated shape":
        var s = test_shape()
        s.translate(0, 1, 0)

        let n = s.normal_at(point(0, 1.70711, -0.70711))

        check: n ~= vector(0, 0.70711, -0.70711)

    test "Computing the normal on a transformed shape":
        var s = test_shape()
        s.scale(1, 0.5, 1).rotate_z(PI/5) 
        
        let n = normal_at(s, point(0, sqrt(2.0)/2, -sqrt(2.0)/2))

        check: n ~= vector(0, 0.97014, -0.24254)

    test "[extra] A Sphere is an Entity":
        var s = sphere()

        check: s is Entity

    test "The normal of a plane is constant everywhere":
        var
            p = plane()
            n1 = p.local_normal_at point(0, 0, 0)
            n2 = p.local_normal_at point(10, 0, -10)
            n3 = p.local_normal_at point(-5, 0, 150)
        
        check:
            n1 ~= vector(0, 1, 0)
            n2 ~= vector(0, 1, 0)
            n3 ~= vector(0, 1, 0)

    test "Intersect with a ray parallel to the plane":
        var
            p = plane()
            r = ray(point(0, 10, 0), vector(0, 0, 1))
            xs = p.local_intersect(r)

        check xs.len == 0

    test "Intersect with a coplanar ray":
        var
            p = plane()
            r = ray(point(0, 0, 0), vector(0, 0, 1))
            xs = local_intersect(p, r)

        check xs.len == 0

    test "A ray intersecting a plane from above":
        var 
            p = plane()
            r = ray(point(0, 1, 0), vector(0, -1, 0))
            xs = local_intersect(p, r)

        check:
            xs.len == 1
            xs[0].t ~= 1
            xs[0].entity == p

    test "A ray intersecting a plane from below":
        var
            p = plane()
            r = ray(point(0, -1, 0), vector(0, 1, 0))
            xs = local_intersect(p, r)

        check:
            xs.len == 1
            xs[0].t ~= 1
            xs[0].entity == p