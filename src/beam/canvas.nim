import strformat
import streams

import real
import colors

type
    Canvas* = object
        w: Positive
        h: Positive
        data: seq[RgbColor]

func `w`*(c: Canvas): Positive = c.w
func `h`*(c: Canvas): Positive = c.h


func canvas*(w, h: Positive): Canvas =
    result = Canvas(
        w: w,
        h: h,
        data: newSeq[RgbColor](w*h)
    )


iterator pixels*(c: Canvas): RgbColor {.inline.} =
    for p in c.data.items:
        yield p


iterator pairs*(c: Canvas): tuple[key: int, val: RgbColor] {.inline.} =
    for p in c.data.pairs:
        yield p

func set_color*(c: var Canvas, x, y: SomeUnsignedInt, color: RgbColor) =
    let index = y.uint * c.w.uint + x.uint
    c.data[index] = color

func get_color*(c: Canvas, x, y: SomeUnsignedInt): RgbColor =
    assert x < c.w.SomeUnsignedInt, "Cannot access a value over the canvas width"
    assert y < c.h.SomeUnsignedInt, "Cannot access a value over the canvas height"
    c.data[y * c.w.SomeUnsignedInt + x]

proc to_ppm*(c: Canvas, s: Stream) =
    s.writeLine "P3"
    s.writeLine fmt"{c.w} {c.h}"
    s.writeLine "255"

    proc convert(v: Real): uint =
        clamp(
            ((v * 255) + 0.5), 0, 255
        ).uint

    proc write_color(s: Stream, pos: var uint32, color: Real): uint32 =
        # PPM lines cannot be over 70 characters long
        const max_pos = 70'u32
        let
            text = $convert(color)
            length = if pos > 0:
                    uint32 (len text) + 1
                else:
                    uint32 len text

        # will writing go over max linewidth?
        if pos + length > max_pos:
            s.write("\n")
            pos = 0

        if pos > 0:
            s.write(" ")

        s.write(text)
        pos += length
        return pos


    for y in 0 ..< c.h.uint32:
        var position = 0'u32

        for x in 0 ..< c.w.uint32:
            let color = c.get_color(x, y)
            position = write_color(s, position, color.r)
            position = write_color(s, position, color.g)
            position = write_color(s, position, color.b)

        if position > 0:
            s.write("\n")


proc to_ppm*(c: Canvas, filename: string) =
    var fs = newFileStream(filename, fmWrite)
    c.to_ppm(fs)
