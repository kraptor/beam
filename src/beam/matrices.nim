import math

import real

import tuples
import points
import vectors

type 
    Matrix4* = object
        data: array[4*4, Real]

    Matrix3* = object
        data: array[3*3, Real]

    Matrix2* = object
        data: array[2*2, Real]

    AnyMatrix* = Matrix4 | Matrix3 | Matrix2

func matrix4*(): Matrix4 = result
func matrix4*(data: array[4*4, SomeNumber]): Matrix4 =
    for i, v in data.pairs: result.data[i] = Real(v)

func matrix3*(data: array[3*3, SomeNumber]): Matrix3 = 
    for i, v in data.pairs: result.data[i] = Real(v)

func matrix2*(data: array[2*2, SomeNumber]): Matrix2 = 
    for i, v in data.pairs: result.data[i] = Real(v)

func `~=`*(a, b: AnyMatrix): bool =
    for i, v in a.data: 
        if not(a.data[i] ~= b.data[i]):
            return false
    true

func `!=`*(a, b: AnyMatrix): bool {.inline.} = not(`~=`(a, b))

func identity*(t: typedesc[Matrix4]): Matrix4 = 
    const IDENTITY_MATRIX_4 = matrix4([
        1,0,0,0,
        0,1,0,0,
        0,0,1,0,
        0,0,0,1
    ])
    IDENTITY_MATRIX_4

func `[]`*(m: Matrix4, row, col: 0..3): Real {.inline.} = m.data[row*4+col]
func `[]`*(m: Matrix3, row, col: 0..2): Real {.inline.} = m.data[row*3+col]
func `[]`*(m: Matrix2, row, col: 0..1): Real {.inline.} = m.data[row*2+col]
func `[]=`*(m: var Matrix4, row, col: 0..3, v: Real) {.inline.} = m.data[row*4+col] = v
func `[]=`*(m: var Matrix3, row, col: 0..2, v: Real) {.inline.} = m.data[row*3+col] = v
func `[]=`*(m: var Matrix2, row, col: 0..1, v: Real) {.inline.} = m.data[row*2+col] = v

func m00*(m: Matrix4): Real {.inline.} = m.data[0]
func m01*(m: Matrix4): Real {.inline.} = m.data[1]
func m02*(m: Matrix4): Real {.inline.} = m.data[2]
func m03*(m: Matrix4): Real {.inline.} = m.data[3]
func m10*(m: Matrix4): Real {.inline.} = m.data[4]
func m11*(m: Matrix4): Real {.inline.} = m.data[5]
func m12*(m: Matrix4): Real {.inline.} = m.data[6]
func m13*(m: Matrix4): Real {.inline.} = m.data[7]
func m20*(m: Matrix4): Real {.inline.} = m.data[8]
func m21*(m: Matrix4): Real {.inline.} = m.data[9]
func m22*(m: Matrix4): Real {.inline.} = m.data[10]
func m23*(m: Matrix4): Real {.inline.} = m.data[11]
func m30*(m: Matrix4): Real {.inline.} = m.data[12]
func m31*(m: Matrix4): Real {.inline.} = m.data[13]
func m32*(m: Matrix4): Real {.inline.} = m.data[14]
func m33*(m: Matrix4): Real {.inline.} = m.data[15]

func `m00=`*(m: var Matrix4, v: Real) {.inline.} = m.data[0]  = v
func `m01=`*(m: var Matrix4, v: Real) {.inline.} = m.data[1]  = v
func `m02=`*(m: var Matrix4, v: Real) {.inline.} = m.data[2]  = v
func `m03=`*(m: var Matrix4, v: Real) {.inline.} = m.data[3]  = v
func `m10=`*(m: var Matrix4, v: Real) {.inline.} = m.data[4]  = v
func `m11=`*(m: var Matrix4, v: Real) {.inline.} = m.data[5]  = v
func `m12=`*(m: var Matrix4, v: Real) {.inline.} = m.data[6]  = v
func `m13=`*(m: var Matrix4, v: Real) {.inline.} = m.data[7]  = v
func `m20=`*(m: var Matrix4, v: Real) {.inline.} = m.data[8]  = v
func `m21=`*(m: var Matrix4, v: Real) {.inline.} = m.data[9]  = v
func `m22=`*(m: var Matrix4, v: Real) {.inline.} = m.data[10] = v
func `m23=`*(m: var Matrix4, v: Real) {.inline.} = m.data[11] = v
func `m30=`*(m: var Matrix4, v: Real) {.inline.} = m.data[12] = v
func `m31=`*(m: var Matrix4, v: Real) {.inline.} = m.data[13] = v
func `m32=`*(m: var Matrix4, v: Real) {.inline.} = m.data[14] = v
func `m33=`*(m: var Matrix4, v: Real) {.inline.} = m.data[15] = v


func m00*(m: Matrix3): Real {.inline.} = m.data[0]
func m01*(m: Matrix3): Real {.inline.} = m.data[1]
func m02*(m: Matrix3): Real {.inline.} = m.data[2]
func m10*(m: Matrix3): Real {.inline.} = m.data[3]
func m11*(m: Matrix3): Real {.inline.} = m.data[4]
func m12*(m: Matrix3): Real {.inline.} = m.data[5]
func m20*(m: Matrix3): Real {.inline.} = m.data[6]
func m21*(m: Matrix3): Real {.inline.} = m.data[7]
func m22*(m: Matrix3): Real {.inline.} = m.data[8]

func m00*(m: Matrix2): Real {.inline.} = m.data[0]
func m01*(m: Matrix2): Real {.inline.} = m.data[1]
func m10*(m: Matrix2): Real {.inline.} = m.data[2]
func m11*(m: Matrix2): Real {.inline.} = m.data[3]


func `*`*(a, b: Matrix4): Matrix4 =
    # for row in 0..3:
    #     for col in 0..3:
    #         result.data[row*4 + col] = 
    #             a.m(row, 0) * b.m(0, col) +
    #             a.m(row, 1) * b.m(1, col) +
    #             a.m(row, 2) * b.m(2, col) +
    #             a.m(row, 3) * b.m(3, col)

    # unrolled
    result.m00 = a.m00 * b.m00 + a.m01 * b.m10 + a.m02 * b.m20 + a.m03 * b.m30
    result.m01 = a.m00 * b.m01 + a.m01 * b.m11 + a.m02 * b.m21 + a.m03 * b.m31
    result.m02 = a.m00 * b.m02 + a.m01 * b.m12 + a.m02 * b.m22 + a.m03 * b.m32
    result.m03 = a.m00 * b.m03 + a.m01 * b.m13 + a.m02 * b.m23 + a.m03 * b.m33

    result.m10 = a.m10 * b.m00 + a.m11 * b.m10 + a.m12 * b.m20 + a.m13 * b.m30
    result.m11 = a.m10 * b.m01 + a.m11 * b.m11 + a.m12 * b.m21 + a.m13 * b.m31
    result.m12 = a.m10 * b.m02 + a.m11 * b.m12 + a.m12 * b.m22 + a.m13 * b.m32
    result.m13 = a.m10 * b.m03 + a.m11 * b.m13 + a.m12 * b.m23 + a.m13 * b.m33

    result.m20 = a.m20 * b.m00 + a.m21 * b.m10 + a.m22 * b.m20 + a.m23 * b.m30
    result.m21 = a.m20 * b.m01 + a.m21 * b.m11 + a.m22 * b.m21 + a.m23 * b.m31
    result.m22 = a.m20 * b.m02 + a.m21 * b.m12 + a.m22 * b.m22 + a.m23 * b.m32
    result.m23 = a.m20 * b.m03 + a.m21 * b.m13 + a.m22 * b.m23 + a.m23 * b.m33

    result.m30 = a.m30 * b.m00 + a.m31 * b.m10 + a.m32 * b.m20 + a.m33 * b.m30
    result.m31 = a.m30 * b.m01 + a.m31 * b.m11 + a.m32 * b.m21 + a.m33 * b.m31
    result.m32 = a.m30 * b.m02 + a.m31 * b.m12 + a.m32 * b.m22 + a.m33 * b.m32
    result.m33 = a.m30 * b.m03 + a.m31 * b.m13 + a.m32 * b.m23 + a.m33 * b.m33

func `*`*(m: Matrix4, b: Tuple): Tuple =
    result.x = m.m00 * b.x + m.m01 * b.y + m.m02 * b.z + m.m03 * b.w
    result.y = m.m10 * b.x + m.m11 * b.y + m.m12 * b.z + m.m13 * b.w
    result.z = m.m20 * b.x + m.m21 * b.y + m.m22 * b.z + m.m23 * b.w
    result.w = m.m30 * b.x + m.m31 * b.y + m.m32 * b.z + m.m33 * b.w

func `*`*[T: Point | Vector](m: Matrix4, b: T): T = T(m * Tuple(b))

func transpose*(m: Matrix4): Matrix4 =
    for col in 0..3:
        for row in 0..3:
            result[col, row] = m[row, col]

func submatrix*(m: Matrix3, row, col: 0..2): Matrix2 =
    for r in 0..2:
        if r == row: continue
        var trow = if r > row: r - 1 else: r
        for c in 0..2:
            if c == col: continue
            result[trow, if c > col: c - 1 else: c] = m[r, c]

func submatrix*(m: Matrix4, row, col: 0..3): Matrix3 =
    for r in 0..3:
        if r == row: continue
        var trow = if r > row: r - 1 else: r
        for c in 0..3:
            if c == col: continue
            result[trow, if c > col: c - 1 else: c] = m[r, c]

func determinant*(m: Matrix2): Real =
    m.m00 * m.m11 - m.m01 * m.m10

func minor*(m: Matrix3, col, row: 0..2): Real =
    m.submatrix(col, row).determinant

func cofactor*(m: Matrix3, col, row: 0..2): Real =
    result = m.minor(col, row)
    if (col + row) mod 2 != 0:
        result = -result

func determinant*(m: Matrix3): Real =
    m.m00 * m.cofactor(0,0) + m.m01 * m.cofactor(0, 1) + m.m02 * m.cofactor(0, 2)

func minor*(m: Matrix4, col, row: 0..3): Real =
    m.submatrix(col, row).determinant

func cofactor*(m: Matrix4, col, row: 0..3): Real =
    result = m.minor(col, row)
    if (col + row) mod 2 != 0:
        result = -result

func determinant*(m: Matrix4): Real =
    m.m00 * m.cofactor(0,0) + m.m01 * m.cofactor(0, 1) + m.m02 * m.cofactor(0, 2) + m.m03 * m.cofactor(0, 3)

func invertible*(m: AnyMatrix): bool {.inline.} = m.determinant != 0

func inverse*(m: Matrix4): Matrix4 =
    if not m.invertible:
        raise newException(Exception, "Matrix is not invertible: " & $m)

    for row in 0..3:
        for col in 0..3:
            let c = m.cofactor(row, col)
            result[col, row] = c / m.determinant

func translation*(x, y, z: Real): Matrix4 =
    matrix4([
        Real 1, 0, 0, x,
             0, 1, 0, y,
             0, 0, 1, z,
             0, 0, 0, 1
    ])


func scaling*(x, y, z: Real): Matrix4 =
    matrix4([
        x, 0, 0, 0,
        0, y, 0, 0,
        0, 0, z, 0,
        0, 0, 0, 1
    ])


func rotation_x*(rad: Real): Matrix4 =
    let 
        c: Real = cos(rad)
        s: Real = sin(rad)

    matrix4([
        1.0, 0,  0, 0,
        0  , c, -s, 0,
        0  , s,  c, 0,
        0  , 0,  0, 1
    ])


func rotation_y*(rad: Real): Matrix4 =
    let 
        c: Real = cos(rad)
        s: Real = sin(rad)

    matrix4([
         c, 0, s, 0,
         0, 1, 0, 0,
        -s, 0, c, 0,
         0, 0, 0, 1
    ])


func rotation_z*(rad: Real): Matrix4 =
    let 
        c: Real = cos(rad)
        s: Real = sin(rad)

    matrix4([
        c, -s, 0, 0,
        s,  c, 0, 0,
        0,  0, 1, 0,
        0,  0, 0, 1
    ])


func shearing*(xy, xz, yx, yz, zx, zy: Real): Matrix4 =
    matrix4([
        1.0, xy, xz, 0,
         yx,  1, yz, 0,
         zx, zy,  1, 0,
          0,  0,  0, 1
    ])


func translate*(m: Matrix4, x, y, z: Real): Matrix4 = 
    translation(x, y, z) * m

func scale*(m: Matrix4, x, y, z: Real): Matrix4 = 
    scaling(x, y, z) * m

func rotate_x*(m: Matrix4, rad: Real): Matrix4 = 
    rotation_x(rad) * m

func rotate_y*(m: Matrix4, rad: Real): Matrix4 = 
    rotation_y(rad) * m

func rotate_z*(m: Matrix4, rad: Real): Matrix4 = 
    rotation_z(rad) * m

func shear*(m: Matrix4, xy, xz, yx, yz, zx, zy: Real): Matrix4 = 
    shearing(xy, xz, yx, yz, zx, zy) * m


func view_transform*(at, to: Point, up: Vector): Matrix4 =
    let
        forward = (to - at).normalize()
        upn = up.normalize()
        left = forward.cross(upn)
        true_up = left.cross(forward)
        orientation = matrix4([
                left.x,     left.y,     left.z, 0,
             true_up.x,  true_up.y,  true_up.z, 0,
            -forward.x, -forward.y, -forward.z, 0,
                     0,          0,          0, 1
        ])

    orientation * translation(-at.x, -at.y, -at.z)