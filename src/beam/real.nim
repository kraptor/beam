type
    Real* = float64

const EPSILON* = 0.0001

func `~=`*(a, b: Real): bool = 
    abs(a-b) < EPSILON