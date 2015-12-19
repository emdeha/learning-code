simCoins <- function() {
  n <- 100
  coins <- sample(c('H', 'T'), replace=T, n)

  ratios = c()

  for (i in seq(1, 10000)) {
    coinPos <- sample(c(1:n), 1)
    coin <- coins[coinPos]

    if (coin == 'H') {
      coins[coinPos] <- sample(c('H','T'), 1)
    } else {
      coins[coinPos] <- 'H'
    }

    ratio = length(coins[coins == 'H']) / length(coins[coins == 'T'])
    ratios[i] = ratio
  }

  mean(ratios)
}
