require('whatwg-fetch')
var restful = require('restful.js')

var api = restful.default('http://api.giphy.com/v1', restful.fetchBackend(fetch))

var gifs = api.custom('gifs').all('trending')
gifs.getAll({ apiKey: 'dc6zaTOxFJmzC' }, { Origin: '*' }).then(function (response) {
  var gifsEnt = response.body()
  console.log(gifsEnt)
})
