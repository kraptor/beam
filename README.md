          _______  _______  _______  __   __ 
         |  _    ||       ||   _   ||  |_|  |
         | |_|   ||    ___||  |_|  ||       |
         |       ||   |___ |       ||       |
         |  _   | |    ___||       ||       |
         | |_|   ||   |___ |   _   || ||_|| |
         |_______||_______||__| |__||_|   |_|

    -- beam, a toy raytracer implemented in Nim --

--------

`beam` is a raytracer implemented in [Nim](https://nim-lang.org)

The implementation follows closely the book [*The Ray Tracer Challenge*](https://pragprog.com/titles/jbtracer/the-ray-tracer-challenge/) by Jamis Buck.

## Implementation:

  - Math:
    - [x] Tuples
    - [x] Points
    - [x] 2D and 3D vectors
    - [x] Matrices
    - [x] Transformations
      - [x] Translation
      - [x] Scaling      
      - [x] Rotation
      - [x] Shearing
      - [x] Transformation chaining
    - [x] Intersections
      - [x] Hits
  - Scene:
    - [x] World
    - [x] Camera
    - Entities:
      - [x] Spheres
      - [x] Planes     
  - Lighting:
    - [x] Phong Lighting
    - [x] Shadows
    - [x] Point lights 
  - Patterns:
    - [x] Base patterns
    - [x] Stripe
    - [x] Gradient
    - [x] Checker
    - [x] Ring
    - Extra:
      - [ ] Radial
      - [ ] Nested
      - [ ] Blended
      - [ ] Perturbed
  - Output formats:
    - [x] PPM 
  - Tests:
    - [x] Chapter 1
    - [x] Chapter 2
    - [x] Chapter 3
    - [x] Chapter 4
    - [x] Chapter 5
    - [x] Chapter 6
    - [x] Chapter 7
    - [x] Chapter 8
    - [x] Chapter 9
    - [x] Chapter 10
    - [ ] Chapter 11
    - [ ] Chapter 12
    - [ ] Chapter 13
    - [ ] Chapter 14
    - [ ] Chapter 15
    - [ ] Chapter 16

## Compilation

    $ nimble build

## Run tests

    $ nimble tests

## Run the raytracer

    $ nimble run -d:danger