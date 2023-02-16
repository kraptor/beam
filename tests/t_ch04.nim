import unittest
import math

import beam/api

suite "Chapter 4 tests":
    
    test "Multiplying by a translation matrix":
        let 
            t = translation(5, -3, 2)
            p = point(-3, 4, 5)

        check: (t * p) ~= point(2, 1, 7)

    test "Multiplying by the inverse of a translation matrix":
        let 
            t = translation(5, -3, 2)
            inv = t.inverse
            p = point(-3, 4, 5)
        
        check: inv * p ~= point(-8, 7, 3)

    test "Translation does not affect vectors":
        let
            t = translation(5, -3, 2)
            v = vector(-3, 4, 5)

        check: (t * v) ~= v

    test "A scaling matrix applied to a point":
        let 
            t = scaling(2, 3, 4)
            p = point(-4, 6, 8)

        check: (t * p) ~= point(-8, 18, 32)

    test "A scaling matrix applied to a vector":
        let 
            t = scaling(2, 3, 4)
            p = vector(-4, 6, 8)

        check: (t * p) ~= vector(-8, 18, 32)

    test "Multiplying by the inverse of a scaling matrix":
        let
            t = scaling(2, 3, 4)
            inv = t.inverse
            v = vector(-4, 6, 8)
        
        check: (inv * v) ~= vector(-2, 2, 2)

    test "Reflection is scaling by a negative value":
        let
            t = scaling(-1, 1, 1)
            p = point(2, 3, 4)
        
        check: (t * p) ~= point(-2, 3, 4)

    test "Rotating a point around the x axis":
        let
            p = point(0, 1, 0)
            half_quarter = rotation_x(PI / 4)
            full_quarter = rotation_x(PI / 2)

        check:
            (half_quarter * p) ~= point(0, sqrt(2.0)/2, sqrt(2.0)/2)
            (full_quarter * p) ~= point(0, 0, 1)

    test "The inverse of an x-rotation rotates in the opposite direction":
        let
            p = point(0, 1, 0)
            half_quarter = rotation_x(PI / 4)
            inv = half_quarter.inverse

        check: (inv * p) ~= point(0, sqrt(2.0)/2, -sqrt(2.0)/2)

    test "Rotating a point around the y axis":
        let
            p = point(0, 0, 1)
            half_quarter = rotation_y(PI / 4)
            full_quarter = rotation_y(PI / 2)

        check:
            (half_quarter * p) ~= point(sqrt(2.0)/2, 0, sqrt(2.0)/2)
            (full_quarter * p) ~= point(1, 0, 0)

    test "Rotating a point around the z axis":
        let
            p = point(0, 1, 0)
            half_quarter = rotation_z(PI / 4)
            full_quarter = rotation_z(PI / 2)

        check:
            (half_quarter * p) ~= point(-sqrt(2.0)/2, sqrt(2.0)/2, 0)
            (full_quarter * p) ~= point(-1, 0, 0)

    test "A shearing transformation moves x in proportion to y":
        let
            t = shearing(1, 0, 0, 0, 0, 0)
            p = point(2, 3, 4)
        
        check: (t * p) ~= point(5, 3, 4)

    test "A shearing transformation moves x in proportion to z":
        let
            t = shearing(0, 1, 0, 0, 0, 0)
            p = point(2, 3, 4)
        
        check: (t * p) ~= point(6, 3, 4)

    test "A shearing transformation moves y in proportion to x":
        let
            t = shearing(0, 0, 1, 0, 0, 0)
            p = point(2, 3, 4)
        
        check: (t * p) ~= point(2, 5, 4)

    test "A shearing transformation moves y in proportion to z":
        let
            t = shearing(0, 0, 0, 1, 0, 0)
            p = point(2, 3, 4)
        
        check: (t * p) ~= point(2, 7, 4)

    test "A shearing transformation moves z in proportion to x":
        let
            t = shearing(0, 0, 0, 0, 1, 0)
            p = point(2, 3, 4)
        
        check: (t * p) ~= point(2, 3, 6)

    test "A shearing transformation moves z in proportion to y":
        let
            t = shearing(0, 0, 0, 0, 0, 1)
            p = point(2, 3, 4)
        
        check: (t * p) ~= point(2, 3, 7)

    test "Individual transformations are applied in sequence":
        let
            p = point(1, 0, 1)
            A = rotation_x(PI/2)
            B = scaling(5, 5, 5)
            C = translation(10, 5, 7)

        let
            p2 = A * p
            p3 = B * p2
            p4 = C * p3

        check:
            p2 ~= point(1, -1, 0)
            p3 ~= point(5, -5, 0)
            p4 ~= point(15, 0, 7)

    test "Chained transformations must be applied in reverse order":
        let
            p = point(1, 0, 1)
            A = rotation_x(PI/2)
            B = scaling(5, 5, 5)
            C = translation(10, 5, 7)

            t = Matrix4.identity.rotate_x(PI/2).scale(5, 5, 5).translate(10, 5, 7)
        
        check:
            (C * B * A * p) ~= point(15, 0, 7)
            (t * p) ~= point(15, 0, 7)
            