var api = restful.default('https://api.giphy.com/v1')

var gifs = api.all('gifs/trending')
gifs.getAll({ apiKey: 'dc6zaTOxFJmzC'}).then(function (response) {
  var gifsEnt = response.body()
  console.log(gifsEnt)
})
