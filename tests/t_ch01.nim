import unittest
import math

import beam/api


suite "Chapter 1 tests":
    test "A tuple with w=1 is a point":
        let p = point(4.3, -4.2, 3.1)
        check:           
            p.x ~= 4.3
            p.y ~= -4.2
            p.z ~= 3.1
            p.w ~= 1
            p is Point

    test "A tuple with w=0 is a vector":
        let v = vector(4.3, -4.2, 3.1)
        check:
            v.x ~= 4.3
            v.y ~= -4.2
            v.z ~= 3.1
            v.w ~= 0
            v is Vector

    test "point() creates tuples with w=1":
        let p = point(4.0, -4, 3)
        check:
            p is Point
            p.w ~= 1
            p ~= Tuple.init(4.0, -4.0, 3.0, 1)

    test "vector() creates tuples with w=0":
        let v = vector(4, -4, 3)
        check:
            v is Vector
            v.w ~= 0
            v ~= Tuple.init(4.0, -4.0, 3.0, 0)
        
        let v32 = vector(4, -4, 3)
        check:
            v32 is Vector
            v32.w ~= 0
            v32 ~= Tuple.init(4.0'f32, -4.0, 3.0, 0)

    test "Adding two tuples":
        let
            a1 = Tuple.init(3f, -2, 5, 1)
            a2 = Tuple.init(-2f, 3, 1, 0)
        check:
            (a1 + a2) ~= Tuple.init(1f, 1, 6, 1)

    test "Subtracting two points":
        let 
            p1 = point(3.0, 2, 1)
            p2 = point(5.0, 6, 7)
            result = p1 - p2
        check:
            result is Vector
            result.w ~= 0
            result ~= vector(-2.0, -4, -6)

    test "Subtracting vector from a point":
        let
            p = point(3.0, 2, 1)
            v = vector(5.0, 6, 7)
            result = p - v
        check:
            result is Point
            result.w ~= 1
            result ~= point(-2.0, -4, -6)

    test "Subtracting two vectors":
        let
            v1 = vector(3.0, 2, 1)
            v2 = vector(5.0, 6, 7)
            result = v1 - v2
        check:
            result is Vector
            result.w ~= 0
            result.w is Real
            result ~= vector(-2.0, -4, -6)

    test "Subtracting a vector from the ZERO vector":
        let
            zero = Vector.ZERO
            v = vector(1.0, -2, 3)
            result = zero - v
        check:
            result is Vector
            result ~= vector(-1.0, 2, -3)

    test "Negating a tuple":
        let
            a = Tuple.init(1, -2, 3, -4)
            result = -a
        check:
            result is Tuple
            result ~= Tuple.init(-1, 2, -3, 4)        

    test "Multiplying a tuple by a scalar":
        let
            a = Tuple.init(1, -2, 3, -4)
            result = a * 3.5
            result2 = 3.5 * a
        check:
            result is Tuple
            result ~= Tuple.init(3.5, -7, 10.5, -14)
            result2 is Tuple
            result2 ~= result

    test "Multiplying a tuple by a fraction":
        let
            a = Tuple.init(1, -2, 3, -4)
            result = a * 0.5
            result2 = 0.5 * a
        check:
            result is Tuple
            result ~= Tuple.init(0.5, -1, 1.5, -2)
            result2 is Tuple
            result2 ~= result

    test "Dividing a tuple by a scalar":
        let
            a = Tuple.init(1, -2, 3, -4)
            result = a / 2
        check:
            result is Tuple
            result ~= Tuple.init(0.5, -1, 1.5, -2)

    test "Computing the magnitude of vector(1, 0, 0)":
        let v = vector(1, 0, 0)
        check:
            v.magnitude ~= 1
    
    test "Computing the magnitude of vector(0, 1, 0)":
        let v = vector(0, 1, 0)
        check:
            v.magnitude ~= 1

    test "Computing the magnitude of vector(0, 0, 1)":
        let v = vector(0, 0, 1)
        check:
            v.magnitude ~= 1

    test "Computing the magnitude of vector(1, 2, 3)":
        let v = vector(1, 2, 3)
        check:
            v.magnitude ~= sqrt(14.0)

    test "Computing the magnitude of vector(-1, -2, -3)":
        let v = vector(-1, -2, -3)
        check:
            v.magnitude ~= sqrt(14.0)

    test "Normalize vector(4, 0, 0) gives (1, 0, 0)":
        let 
            v = vector(4, 0, 0)
            result = v.normalize
        check:
            result ~= vector(1, 0, 0)

    test "Normalize vector(1, 2, 3)":
        let 
            v = vector(1, 2, 3)
            result = v.normalize
        check:
            v.magnitude_squared ~= 14
            result ~= vector(1/sqrt(14.0), 2/sqrt(14.0), 3/sqrt(14.0))

    test "The magnitude of a normalized vector":
        let
            v = vector(1, 2, 3)
            result = v.normalize
        check:
            result.magnitude ~= 1

    test "The dot product of two vectors":
        let
            a = vector(1, 2, 3)
            b = vector(2, 3, 4)
        check:
            dot(a, b) ~= 20

    test "The cross product of two vectors":
        let
            a = vector(1, 2, 3)
            b = vector(2, 3, 4)
        check:
            cross(a, b) ~= vector(-1,  2, -1)
            cross(b, a) ~= vector( 1, -2,  1)
