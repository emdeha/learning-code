rowDie <- function(n) {
    eqCount = 0

    for (i in 1:n) {
        smpl = sample(1:6, 10, replace=T)
        ones = length(Filter(function(x) x==1, smpl))
        sixths = length(Filter(function(x) x==6, smpl))
        if (ones == sixths) {
            eqCount = eqCount + 1
        }
    }

    eqCount / n
}
