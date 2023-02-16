import streams

import beam/api
# import beam/book/ch7_scene

var
    a_world = world(
        @[
            point_light(
                point(3, 8, 0),
                color(1, 1, 1),
            ).Light,
        ],
        entities = @[ 
            Entity sphere(
                material = material(
                    color = color(0.2, 0.7, 0.4), 
                    ambient = 0.7, 
                    diffuse = 0.0, 
                    specular = 0.0,
                    shininess = 0.0,
                    reflective = 0.0
                ),
                translation(1, -0.7, -3)*scaling(0.3, 0.3, 0.3)
            ),

            sphere(
                material = material(
                    color = color(1.0, 0.2, 0.4), 
                    ambient = 0.7, 
                    diffuse = 0.0, 
                    specular = 0.0,
                    shininess = 0.0,
                    reflective = 0.0
                ),
                translation(0, 0, -5)
            ),
            
            sphere(
                material = material(
                    color = color(0.0, 0.0, 1.0), 
                    ambient = 0.7, 
                    diffuse = 0.0, 
                    specular = 0.0,
                    shininess = 0.0,
                    reflective = 0.0
                ),
                translation(-1, -0.7, -4) * scaling(0.3, 0.3, 0.3)
            ),

            sphere(
                material = material(
                    color = color(0.1, 0.4, 0.7), 
                    ambient = 0.7, 
                    diffuse = 0.0, 
                    specular = 0.0,
                    shininess = 0.0,
                    reflective = 0.0
                ),
                translation(14, 5, -20) * scaling(20, 20, 20)
            ),
        ]
    )

    floor = plane(
        transform = translation(0, -1, 0), #* scaling(100, 0.01, 100),
        material = material(
            color = color(1, 1, 1), 
            ambient = 0.8, 
            diffuse = 1, 
            specular = 0,
            shininess = 0,
            reflective = 0
        ),
    )
    
    back = sphere(
        material = material(
            color = color(0.1, 0.4, 0.7), 
            ambient = 0.5, 
            diffuse = 0, 
            specular = 0,
            shininess = 0.0,
            reflective = 0
        ),
        transform = translation(0, 0, -4000) * scaling(4000, 4000, 0.01)
    )

when isMainModule:
    echo "Beam - nim raytracer"

    const
        w = 1920
        h = 1080
        camera = camera(w, h, PI/4)
        
    echo "* Rendering scene 0"
    camera.render(a_world).to_ppm("image_00.ppm")

    for e in a_world.entities:
        e.material.specular = 0.6
        e.material.diffuse = 0.4
        e.material.shininess = 0.8    
    echo "* Rendering scene 1"
    camera.render(a_world).to_ppm("image_01.ppm")

    a_world.entities.add(floor)
    a_world.entities.add(back)

    floor.material.ambient = 1
    echo "* Rendering scene 2"
    camera.render(a_world).to_ppm("image_02.ppm")

    floor.material.ambient = 0.5
    echo "* Rendering scene 3"
    camera.render(a_world).to_ppm("image_03.ppm")

    for e in a_world.entities:
        e.material.reflective = 0.25
    echo "* Rendering scene 4"
    camera.render(a_world).to_ppm("image_04.ppm")

    # ch7_scene(100, 50).to_ppm("ch7_scene.ppm")