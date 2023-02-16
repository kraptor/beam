import unittest

import beam/api


suite "Chapter 3 tests":
    test "Constructing and inspecting a 4x4 matrix":
        let m = matrix4([
            1.0,  2  ,  3  , 4  ,
            5.5,  6.5,  7.5, 8.5,
            9  , 10  , 11  , 12 ,
            13.5, 14.5, 15.5, 16.5
        ])

        check:
            m.m00 ~= 1    and m[0,0] ~= 1
            m.m03 ~= 4    and m[0,3] ~= 4   
            m.m10 ~= 5.5  and m[1,0] ~= 5.5 
            m.m12 ~= 7.5  and m[1,2] ~= 7.5 
            m.m22 ~= 11   and m[2,2] ~= 11  
            m.m30 ~= 13.5 and m[3,0] ~= 13.5
            m.m32 ~= 15.5 and m[3,2] ~= 15.5

    test "A 2x2 matrix ought to be representable":
        let m = matrix2([
            -3,  5,
            1, -2
        ])
        check:
            m.m00 ~= -3 and m[0,0] ~= -3
            m.m01 ~=  5 and m[0,1] ~=  5
            m.m10 ~=  1 and m[1,0] ~=  1
            m.m11 ~= -2 and m[1,1] ~= -2

    test "A 3x3 matrix ought to be representable":
        let m = matrix3([
            -3,  5,  0,
            1, -2, -7,
            0,  1,  1
        ])

        check:
            m.m00 ~= -3 and m[0,0] ~= -3
            m.m11 ~= -2 and m[1,1] ~= -2
            m.m22 ~=  1 and m[2,2] ~=  1

    test "Matrix equality with identical matrices":
        let A = matrix4([
            1, 2, 3, 4,
            5, 6, 7, 8,
            9, 8, 7, 6,
            5, 4, 3, 2
        ])

        let B = matrix4([
            1, 2, 3, 4,
            5, 6, 7, 8,
            9, 8, 7, 6,
            5, 4, 3, 2
        ])

        check: A ~= B
    
    test "Matrix equality with different matrices":
        let A = matrix4([
                1, 2, 3, 4,
                5, 6, 7, 8,
                9, 8, 7, 6,
                5, 4, 3, 2
            ])

        let B = matrix4([
                2, 3, 4, 5,
                6, 7, 8, 9,
                8, 7, 6, 5,
                4, 3, 2, 1
            ])
        
        check: A != B

    test "Multiplying two matrices":
        let  A = matrix4([
            1, 2, 3, 4,
            5, 6, 7, 8,
            9, 8, 7, 6,
            5, 4, 3, 2
        ])

        let B = matrix4([
            -2, 1, 2, 3,
             3, 2, 1, -1,
             4, 3, 6, 5,
             1, 2, 7, 8
        ]) 

        var
            result = A*B
            expected = matrix4([
                20, 22,  50, 48,
                44, 54, 114, 108,
                40, 58, 110, 102,
                16, 26,  46, 42
            ])

        check: result ~= expected

    test "A matrix multiplied by a tuple":
        let A = matrix4([
            1, 2, 3, 4,
            2, 4, 4, 2,
            8, 6, 4, 1,
            0, 0, 0, 1
        ])

        let 
            b = Tuple.init(1, 2, 3, 1)
            result = A * b

        check:
            result is Tuple
            result ~= Tuple.init(18, 24, 33, 1)

    test "Multiplying a matrix by the identity matrix":
        let A = matrix4([
            0, 1, 2 ,  4,
            1, 2, 4 ,  8,
            2, 4, 8 , 16,
            4, 8, 16, 32
        ])

        let result = A * Matrix4.identity

        check: result ~= A

    test "Multiplying the identity matrix by a tuple":
        let 
            a = Tuple.init(1, 2, 3, 4)
            result = Matrix4.identity * a

        check: result ~= a

    test "Transposing a matrix":
        let A = matrix4([
                0, 9, 3, 0,
                9, 8, 0, 8,
                1, 8, 5, 3,
                0, 0, 5, 8
            ])
        let result = A.transpose

        check: result ~= matrix4([
                0, 9, 1, 0,
                9, 8, 8, 0,
                3, 0, 5, 5,
                0, 8, 3, 8
            ])

    test "Transposing the identity matrix":
        check:
            Matrix4.identity.transpose ~= Matrix4.identity

    test "Calculate the determinant of a 2x2 matrix":
        let a = matrix2([
            1, 5,
            -3, 2
        ])
        check: a.determinant ~= 17

    test "A submatrix of a 3x3 matrix is a 2x2 matrix":
        let a = matrix3([
             1, 5,  0,
            -3, 2,  7,
             0, 6, -3
        ])
        check:
            a.submatrix(0, 2) ~= matrix2([
                -3, 2,
                 0, 6
            ])

    test "A submatrix of a 4x4 matrix is a 3x3 matrix":
        let a = matrix4([
            -6, 1,  1 ,6,
            -8, 5,  8 ,6,
            -1, 0,  8 ,2,
            -7, 1, -1, 1,
        ])
        check:
            a.submatrix(2, 1) ~= matrix3([
                -6,  1 , 6,
                -8,  8 , 6,
                -7, -1, 1
            ])

    test "Calculating a minor of a 3x3 matrix":
        let a = matrix3([
            3,  5,  0,
            2, -1, -7,
            6, -1,  5
        ])

        let b = submatrix(a, 1, 0)

        check:
            b.determinant ~= 25
            a.minor(1, 0) ~= 25

    test "Calculating a cofactor of a 3x3 matrix":
        let a = matrix3([
            3,  5,  0,
            2, -1, -7,
            6, -1,  5
        ])

        check:
            a.minor(0,0) ~= -12
            a.cofactor(0, 0) ~= -12
            a.minor(1, 0) ~= 25
            a.cofactor(1, 0) ~= -25

    test "Calculating the determinant of a 3x3 matrix":
        let a = matrix3([
             1, 2,  6,
            -5, 8, -4,
             2, 6,  4
        ])

        check:
            a.cofactor(0, 0) ~= 56
            a.cofactor(0, 1) ~= 12
            a.cofactor(0, 2) ~= -46
            a.determinant ~= -196

    test "Calculating the determinant of a 4x4 matrix":
        let a = matrix4([
            -2, -8,  3,  5,
            -3,  1,  7,  3,
             1,  2, -9,  6,
            -6,  7,  7, -9
        ])

        check:
            a.cofactor(0, 0) ~= 690
            a.cofactor(0, 1) ~= 447
            a.cofactor(0, 2) ~= 210
            a.cofactor(0, 3) ~= 51
            a.determinant ~= -4071

    test "Testing an invertible matrix for invertibility":
        let a = matrix4([
            6,  4, 4,  4,
            5,  5, 7,  6,
            4, -9, 3, -7,
            9,  1, 7, -6
        ])
        
        check:
            a.determinant ~= -2120
            a.invertible == true

    test "Testing a noninvertible matrix for invertibility":
        let a = matrix4([
            -4,  2, -2, -3,
             9,  6,  2,  6,
             0, -5,  1, -5,
             0,  0,  0,  0
        ])

        check:
            a.determinant ~= 0
            a.invertible == false

    test "Calculating the inverse of a matrix":
        let a = matrix4([
            -5,  2,  6, -8,
             1, -5,  1,  8,
             7,  7, -6, -7,
             1, -3,  7,  4
        ])

        let b = a.inverse

        check:
            a.determinant ~= 532
            a.cofactor(2, 3) ~= -160
            b[3, 2] ~= -160/532
            a.cofactor(3, 2) ~= 105
            b[2, 3] ~= 105/532
            b ~= matrix4([
                 0.21805,  0.45113,  0.24060, -0.04511,
                -0.80827, -1.45677, -0.44361,  0.52068,
                -0.07895, -0.22368, -0.05263,  0.19737,
                -0.52256, -0.81391, -0.30075,  0.30639
            ])

    test "Calculating the inverse of another matrix":
        let a = matrix4([
             8, -5,  9,  2,
             7,  5,  6,  1,
            -6,  0,  9,  6,
            -3,  0, -9, -4
        ])

        check: a.inverse ~= matrix4([
            -0.15385, -0.15385, -0.28205, -0.53846,
            -0.07692,  0.12308,  0.02564,  0.03077,
             0.35897,  0.35897,  0.43590,  0.92308,
            -0.69231, -0.69231, -0.76923, -1.92308
        ])

    test "Calculating the inverse of a third matrix":
        let a = matrix4([
             9,  3,  0,  9,
            -5, -2, -6, -3,
            -4,  9,  6,  4,
            -7,  6,  6,  2
        ])

        check: a.inverse ~= matrix4([
            -0.04074, -0.07778,  0.14444, -0.22222,
            -0.07778,  0.03333,  0.36667, -0.33333,
            -0.02901, -0.14630, -0.10926,  0.12963,
             0.17778,  0.06667, -0.26667,  0.33333
        ])

    test "Multiplying a product by its inverse":
        let a = matrix4([
             3, -9,  7,  3,
             3, -8,  2, -9,
            -4,  4,  4,  1,
            -6,  5, -1,  1
        ])
        let b = matrix4([
            8,  2, 2, 2,
            3, -1, 7, 0,
            7,  0, 5, 4,
            6, -2, 0, 5
        ])
        let c = a * b

        check: (c * b.inverse) ~= a