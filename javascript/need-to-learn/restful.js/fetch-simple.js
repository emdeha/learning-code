var req = new Request('https://images.duckduckgo.com/iu/?u=http%3A%2F%2F4.bp.blogspot.com%2F-O-6vxSiyvbk%2FUClib6CiR0I%2FAAAAAAAAQaI%2F5Fr1dI-kQBI%2Fs1600%2FFlowers%2Bbeauty%2Bdesktop%2Bwallpapers.%2B%281%29.jpg&f=1')

fetch(req).then(function (response) {
  return response.blob()
}).then(function (response) {
  var img = document.querySelector('img')
  var objectURL = URL.createObjectURL(response)
  img.src = objectURL
})
