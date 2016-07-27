var express = require('express')
var app         = express()
var bodyParser  = require('body-parser')
var morgan      = require('morgan')
var mongoose    = require('mongoose')

var jwt    = require('jsonwebtoken')
var config = require('./config')
var User   = require('./app/models/user')

var port = process.env.PORT || 8080
mongoose.connect(config.database)
app.set('superSecret', config.secret)

app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

app.use(morgan('dev'))

app.get('/', function (req, res) {
  res.send('Hello! The API is at http://localhost:' + port + '/api')
})

app.get('/setup', function (req, res) {
  var nick = new User({
    name: 'Nick',
    password: 'password',
    admin: true
  })

  nick.save(function (err) {
    if (err) throw err

    console.log('User created successfully')
    res.json({ success: true })
  })
})

app.listen(port)
console.log('Magic happens at http://localhost:' + port)
