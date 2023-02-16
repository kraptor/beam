import math
import real
import matrices
import rays
import points
import vectors
import worlds
import canvas
import computations

type
    Camera* = object
        hsize: Positive
        vsize: Positive
        fov: Real
        transform: Matrix4
        transform_inverse: Matrix4
        pixel_size: Real
        half_width: Real
        half_height: Real


func camera*(hsize, vsize: Positive, fov: Real): Camera =
    let
        half_view = tan(fov / 2.0)
        aspect = hsize / vsize

    var
        half_width = half_view
        half_height = half_view

    if aspect >= 1:
        half_height = half_view / aspect
    else:
        half_width = half_view * aspect

    var pixel_size = (half_width * 2) / hsize.Real

    Camera(
        hsize: hsize,
        vsize: vsize,
        fov: fov,
        transform: Matrix4.identity,
        transform_inverse: Matrix4.identity,
        pixel_size: pixel_size,
        half_width: half_width,
        half_height: half_height,
    )


func hsize*(c: Camera): Positive {.inline.} = c.hsize
func vsize*(c: Camera): Positive {.inline.} = c.vsize
func fov*(c: Camera): Real {.inline.} = c.fov
func pixel_size*(c: Camera): Real {.inline.} = c.pixel_size

func transform*(c: Camera): Matrix4 {.inline.} = c.transform

func `transform=`*(c: var Camera, transform: Matrix4) =
    c.transform = transform
    c.transform_inverse = transform.inverse()

func ray_for_pixel*(c: Camera, x, y: uint): Ray =
    assert x < c.hsize.uint
    assert y < c.vsize.uint

    let
        # the offset from the edge of the canvas to the pixel's center
        x_offset = (x.Real + 0.5) * c.pixel_size
        y_offset = (y.Real + 0.5) * c.pixel_size

        # the untransformed coordinates of the pixel in world space.
        # (remember that the camera looks toward -z, so +x is to the *left*.)
        world_x = c.half_width - x_offset
        world_y = c.half_height - y_offset

        # using the camera matrix, transform the canvas point and the origin,
        # and then compute the ray's direction vector.
        # (remember that the canvas is at z=-1)
        pixel = c.transform_inverse * point(world_x, world_y, -1)
        origin = c.transform_inverse * point(0, 0, 0)
        direction = (pixel - origin).normalize()

    ray(origin, direction)

func render*(c: Camera, w: World): Canvas =
    result = canvas(c.hsize, c.vsize)

    for y in 0.uint ..< c.vsize.uint:
        for x in 0.uint ..< c.hsize.uint:
            let 
                ray = ray_for_pixel(c, x, y)
                color = w.color_at(ray)
            
            result.set_color(x, y, color)

# import colors
# import std/threadpool
# # {.experimental: "parallel".}

# proc render_line(width: uint, linenum: uint, c: Camera, w: World): seq[Color] =
#     result = newSeq[Color](width)
#     debugEcho "Line: " & $linenum & " W: " & $linenum
    
#     for x in 0.uint ..< width:
#         let 
#             ray = ray_for_pixel(c, x, linenum)
#             color = w.color_at(ray)
#         result[x] = color
#         debugEcho "Line: " & $linenum & " X: " & $x

# proc render_parallel*(c: Camera, w: World): Canvas =
#     let width = c.hsize.uint
#     let line_count = c.vsize.uint
#     var lines = newSeq[FlowVar[seq[Color]]](line_count)

#     result = canvas(width, line_count)

#     for linenum in 0 ..< line_count:
#         debugEcho "Spawn: " & $linenum
#         lines[linenum] = spawn render_line(width, linenum, c, w)

#     debugEcho "Waiting for render..."
#     sync()
#     debugEcho "sync"

#     for y in 0 ..< lines.len:
#         for x in 0 ..< width:
#             let color = lines[y].FlowVar)
#             result.set_color(x, y, color)