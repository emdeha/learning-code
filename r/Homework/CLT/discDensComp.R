discComp <- function() {
    plot(0:20, dpois(0:20, lambda=2), pch=0)
    points(0:20, dpois(0:20, lambda=6), pch=16)
    points(0:20, dpois(0:20, lambda=10), pch=25)
}
