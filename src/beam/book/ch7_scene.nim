import math
import ../api


proc ch7_scene*(width = 100, height: Positive = 50): Canvas =
    var floor = sphere()
        .scale(10, 0.01, 10)

    floor.material = material()
    floor.material.color = color(1, 1, 1)
    floor.material.specular = 0.3
    floor.material.reflective = 0.2

    var left_wall: Entity = sphere()
        .translate(0, 0, 5)
        .rotate_y(-PI/4)
        .rotate_x(PI/2)
        .scale(10, 0.01, 10)

    left_wall.material = material()
    left_wall.material.color = color(0.6, 0.3, 0.9)
    left_wall.material.specular = 0
    left_wall.material.reflective = 0.3

    var right_wall = sphere()
        .translate(0, 0, 5)
        .rotate_y(PI/4)
        .rotate_x(PI/2)
        .scale(10, 0.01, 10)
    
    right_wall.material = material()
    right_wall.material.color = color(1.0, 0.4, 0.4)
    right_wall.material.specular = 0
    right_wall.material.reflective = 0.3

    var world = world()
    world.lights.add(
        point_light(
            point(-10, 10, -10),
            color(1, 1, 1),
        )
    )

    var middle = sphere()
        .translate(-0.5, 1, 0.5)

    middle.material = material()
    middle.material.color = color(0.1, 1, 0.5)
    middle.material.diffuse = 0.7
    middle.material.specular = 0.3

    var right = sphere()
        .translate(1.5, 0.5, -0.5)
        .scale(0.5, 0.5, 0.5)

    right.material = material()
    right.material.color = color(0.5, 1, 0.1)
    right.material.diffuse = 0.7
    right.material.specular = 0.3

    var left = sphere()
        .translate(-1.5, 0.33, -0.75)
        .scale(0.33, 0.33, 0.33)

    left.scale(0.4, 1.0, 1.0)
    left.rotate_z(0.3)

    left.material = material()
    left.material.color = color(1, 0.8, 0.1)
    left.material.diffuse = 0.7
    left.material.specular = 0.3

    world.entities.add([
        floor,
        left_wall, 
        right_wall,
        middle,
        right,
        left
    ])

    var camera = camera(width, height, PI/3)
    camera.transform = view_transform(
        point(0, 1.5, -5),
        point(0, 1, 0),
        vector(0, 1, 0)
    )

    result = camera.render(world)