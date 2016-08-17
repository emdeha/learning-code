var fs = require('fs')

var parse = function (str) {
  var currentSection = { name: null, fields: [] }
  var categories = []

  str.split(/\r?\n/).forEach(function (line) {
    var match
    if (line.match(/^\s*(;.*)?$/)) {
      return
    } else if (match = line.match(/^\[(.*)\]$/)) {
      currentSection = { name: match[1], fields: [] }
      categories.push(currentSection)
    } else if (match = line.match(/^(\w+)=(.+)$/)) {
      currentSection.fields.push({ key: match[1], value: match[2] })
    } else {
      throw new Error('Invalid line: ' + line)
    }
  })

  return categories
}

fs.readFile('test.ini', {encoding: 'utf-8'}, function (err, str) {
  if (err) return console.error(err)
  console.log(JSON.stringify(parse(str)))
})
