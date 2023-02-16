import unittest
import streams
import strutils

import beam/api


suite "Chapter 2 tests":
    test "Colors are (red, green, blue) tuples":
        let c = color(-0.5, 0.4, 1.7)
        check:           
            c.r ~= -0.5
            c.g ~= 0.4
            c.b ~= 1.7

    test "Adding colors (linear)":
        let 
            c1 = color(0.9, 0.6, 0.75)
            c2 = color(0.7, 0.1, 0.25)
            result = c1 + c2
        check:
            result ~= color(1.6, 0.7, 1.0) # alpha is added, too

    test "Substracting colors (linear)":
        let 
            c1 = color(0.9, 0.6, 0.75)
            c2 = color(0.7, 0.1, 0.25)
            result = c1 - c2
        check:
            result ~= color(0.2, 0.5, 0.5)

    test "Multiplying a color by a scalar":
        let
            c = color(0.2, 0.3, 0.4)
            result = c * 2
            result2 = 2 * c
        check:
            result ~= color(0.4, 0.6, 0.8)
            result2 ~= color(0.4, 0.6, 0.8)

    test "Multiplying colors":
        let
            c1 = color(1, 0.2, 0.4)
            c2 = color(0.9, 1, 0.1)
            result = c1 * c2
        check:
            result ~= color(0.9, 0.2, 0.04)

    test "Creating a canvas":
        let c = canvas(10, 20)
        check:
            c.w == 10
            c.h == 20
        
        for color in c.pixels:
            check color ~= color(0, 0, 0)

    test "Writing pixels to a canvas":
        let red = color(1, 0, 0)
        var c = canvas(10, 20)
        
        c.set_color(2, 3, red)

        check:
            c.get_color(2, 3) ~= red

    test "Constructing the PPM header":
        let c = canvas(5, 3)
        var s = newStringStream()
                   
        c.to_ppm(s)
        s.setPosition(0)
        
        check:
            s.readLine == "P3"
            s.readLine == "5 3"
            s.readLine == "255"

    test "Constructing the PPM pixel data":
        var 
            s = newStringStream()
            c = canvas(5, 3)
        let
            c1 = color(1.5, 0, 0)
            c2 = color(0, 0.5, 0)
            c3 = color(-0.5, 0, 1)
        
        c.set_color(0, 0, c1)
        c.set_color(2, 1, c2)
        c.set_color(4, 2, c3)
        c.to_ppm(s)
        s.setPosition(0)

        check:
            s.readLine == "P3"
            s.readLine == "5 3"
            s.readLine == "255"
            s.readLine == "255 0 0 0 0 0 0 0 0 0 0 0 0 0 0"
            s.readLine == "0 0 0 0 0 0 0 128 0 0 0 0 0 0 0"
            s.readLine == "0 0 0 0 0 0 0 0 0 0 0 0 0 0 255"

    test "Splitting long lines in PPM files":
        var c = canvas(10, 2)
        const col = color(1, 0.8, 0.6)

        for y in 0'u ..< 2:
            for x in 0'u ..< 10:
                c.set_color(x, y, col)

        var s = newStringStream()
        c.to_ppm(s)
        s.setPosition 0

        check:
            s.readLine == "P3"
            s.readLine == "10 2"
            s.readLine == "255"
            s.readLine == "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204"
            s.readLine == "153 255 204 153 255 204 153 255 204 153 255 204 153"
            s.readLine == "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204"
            s.readLine == "153 255 204 153 255 204 153 255 204 153 255 204 153"

    test "PPM files are terminated by a newline character":
        let c = canvas(5, 3)
        var s = newStringStream()
                   
        c.to_ppm(s)
        s.setPosition(0)

        check:
            s.readAll().endsWith("\n")