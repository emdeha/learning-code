discComp <- function() {
    plot(0:20, dpois(0:20, lambda=2))
    points(0:20, dpois(0:20, lambda=6), col="red")
    points(0:20, dpois(0:20, lambda=10), col="blue")
}
