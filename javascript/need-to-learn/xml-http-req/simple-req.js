var reqListener = function () {
  console.log(this.responseText)
}

var oReq = new XMLHttpRequest()
oReq.addEventListener('load', reqListener)
oReq.open('GET', 'https://raw.githubusercontent.com/emdeha/teaching-statistics/master/02-univariate-data/exploration.txt', true)
oReq.send()
