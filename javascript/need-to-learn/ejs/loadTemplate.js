console.log('loading templates')
var html = new EJS({url: './cleaning.ejs'}).render({
  title: 'Cleaning stuff',
  supplies: ['hello', 'there', 'ejs']
})

var elem = document.createElement('div')
elem.innerHTML = html
document.body.appendChild(elem)
