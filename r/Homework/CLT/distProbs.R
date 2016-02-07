geomProb <- function() {
    sum (dgeom(4:11, 0.123))
}

poisProb <- function() {
    sum (dpois(8:17, 2))
}

normQuant <- function() {
    x = qnorm(0.78, mean=10, sd=2)
    c(-x,x)
}

tQuant <- function() {
    x = qt(0.44, df=4)
    c(-x,x)
}

chisqQuant <- function() {
    x = qchisq(0.55 + pchisq(2, df=5), df=5)
    x
}
