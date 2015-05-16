CLTt <- function(n) {
    df = 7
    sigma = sqrt(df / (df-2))
    results = c()
    for (i in 1:1000) {
        x = rt(n, df)
        results[i] = (mean(x)/sigma)*sqrt(n)
    }

    results
}

CLTexp <- function(n) {
    rate = 5
    lambda = 1/rate
    mu = 1/lambda
    sigma = 1/lambda
    results = c()
    for (i in 1:1000) {
        x = rexp(n, rate)
        results[i] = ((mean(x) - mu)/sigma)*sqrt(n)
    }

    results
}
