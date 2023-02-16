import unittest

import beam/api


type TestPattern = ref object of Pattern

func test_pattern(): TestPattern = 
    result = TestPattern()
    result.init_pattern()


method pattern_at(pattern: TestPattern, point: Point): Color =
    color(point.x, point.y, point.z)


suite "Chapter 10":
    setup:
        const
            black = Color.BLACK
            white = Color.WHITE

    test "Creating a stripe pattern":
        let pattern = stripe_pattern(white, black)

        check:
            pattern.a ~= white
            pattern.b ~= black

    test "A stripe pattern is constant in y":
        let pattern = stripe_pattern(white, black)

        check:
            pattern.pattern_at(point(0, 0, 0)) ~= white
            pattern.pattern_at(point(0, 1, 0)) ~= white
            pattern.pattern_at(point(0, 2, 0)) ~= white

    test "A stripe pattern is constant in z":
        let pattern = stripe_pattern(white, black)

        check:
            pattern_at(pattern, point(0, 0, 0)) ~= white
            pattern_at(pattern, point(0, 0, 1)) ~= white
            pattern_at(pattern, point(0, 0, 2)) ~= white

    test "A stripe pattern alternates in x":
        let pattern = stripe_pattern(white, black)

        check:
            pattern_at(pattern, point(0, 0, 0)) ~= white
            pattern_at(pattern, point(0.9, 0, 0)) ~= white
            pattern_at(pattern, point(1, 0, 0)) ~= black
            pattern_at(pattern, point(-0.1, 0, 0)) ~= black
            pattern_at(pattern, point(-1, 0, 0)) ~= black
            pattern_at(pattern, point(-1.1, 0, 0)) ~= white

    test "Lighting with a pattern applied":
        var
            m = material()
        
        m.pattern = stripe_pattern(color(1, 1, 1), color(0, 0, 0))
        m.ambient = 1
        m.diffuse = 0
        m.specular = 0

        let
            entity = sphere()
            eyev = vector(0, 0, -1)
            normalv = vector(0, 0, -1)
            light = point_light(point(0, 0, -10), color(1, 1, 1))
            c1 = lighting(m, entity, light, point(0.9, 0, 0), eyev, normalv, false)
            c2 = lighting(m, entity, light, point(1.1, 0, 0), eyev, normalv, false)

        check:
            c1 ~= color(1, 1, 1)
            c2 ~= color(0, 0, 0)

    test "Stripes with an object transformation":
        var entity = sphere()
        entity.transform = scaling(2, 2, 2)

        let 
            pattern = stripe_pattern(white, black)
            c = pattern.pattern_at_entity(entity, point(1.5, 0, 0))
        
        check c ~= white
        
    test "Stripes with a pattern transformation":
        let
            entity = sphere()
            pattern = stripe_pattern(white, black, scaling(2, 2, 2))
            c = pattern_at_entity(pattern, entity, point(1.5, 0, 0))
        
        check: c ~= white

    test "Stripes with both an object and a pattern transformation":
        var entity = sphere()
        entity.transform = scaling(2, 2, 2)

        var pattern = stripe_pattern(white, black)
        pattern.transform = translation(0.5, 0, 0)

        let c = pattern_at_entity(pattern, entity, point(2.5, 0, 0))

        check: c ~= white

    test "The default pattern transformation":
        let pattern = test_pattern()

        check pattern.transform ~= Matrix4.identity

    test "Assigning a transformation to a pattern":
        var pattern = test_pattern()
        pattern.transform = translation(1, 2, 3)

        check pattern.transform ~= translation(1, 2, 3)

    test "A pattern with an object transformation":
        var shape = sphere()
        shape.transform = scaling(2, 2, 2)

        let 
            pattern = test_pattern()
            c = pattern.pattern_at_entity(shape, point(2, 3, 4))
        
        check c ~= color(1, 1.5, 2)

    test "A pattern with a pattern transformation":
        var
            shape = sphere()
            pattern = test_pattern()
        
        pattern.transform = scaling(2, 2, 2)
        let c = pattern.pattern_at_entity(shape, point(2, 3, 4))

        check c ~= color(1, 1.5, 2)

    test "A pattern with both an object and a pattern transformation":
        var 
            shape = sphere()
            pattern = test_pattern()

        shape.transform = scaling(2, 2, 2)
        pattern.transform = translation(0.5, 1, 1.5)

        let c = pattern.pattern_at_entity(shape, point(2.5, 3, 3.5))
        
        check c ~= color(0.75, 0.5, 0.25)

    test "A gradient interpolates between colors":
        let 
            pattern = gradient_pattern(white, black)
        
        check:
            pattern.pattern_at(point(0, 0, 0)) ~= white
            pattern.pattern_at(point(0.5, 0, 0)) ~= color(0.5, 0.5, 0.5)
            pattern.pattern_at(point(0.75, 0, 0)) ~= color(0.25, 0.25, 0.25)

    test "A ring should extend in both x and z":
        let
            pattern = ring_pattern(white, black)
        
        check:
            pattern_at(pattern, point(0, 0, 0)) ~= white
            pattern_at(pattern, point(1, 0, 0)) ~= black
            pattern_at(pattern, point(0, 0, 1)) ~= black
            # 0.708 = just slightly more than √2/2
            pattern_at(pattern, point(0.708, 0, 0.708)) ~= black

    test "Checkers should repeat in x":
        let
            pattern = checkers_pattern(white, black)
        
        check:
            pattern_at(pattern, point(0, 0, 0)) ~= white
            pattern_at(pattern, point(0.99, 0, 0)) ~= white
            pattern_at(pattern, point(1.01, 0, 0)) ~= black
    
    test "Checkers should repeat in y":
        let
            pattern = checkers_pattern(white, black)

        check:
            pattern_at(pattern, point(0, 0, 0)) ~= white
            pattern_at(pattern, point(0, 0.99, 0)) ~= white
            pattern_at(pattern, point(0, 1.01, 0)) ~= black
    
    test "Checkers should repeat in z":
        let
            pattern = checkers_pattern(white, black)

        check:
            pattern_at(pattern, point(0, 0, 0)) ~= white
            pattern_at(pattern, point(0, 0, 0.99)) ~= white
            pattern_at(pattern, point(0, 0, 1.01)) ~= black