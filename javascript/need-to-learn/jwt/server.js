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
var apiRoutes = express.Router()

apiRoutes.post('/authenticate', function (req, res) {
  User.findOne({
    name: req.body.name
  }, function (err, user) {
    if (err) throw err
    if (!user) {
      return res.json({ success: false, message: 'User not found' })
    }

    if (user.password !== req.body.password) {
      return res.json({ success: false, message: 'Wrong password' })
    }

    var token = jwt.sign(user, app.get('superSecret'))

    return res.json({ success: true, message: 'Success', token: token })
  })
})

apiRoutes.use(function (req, res, next) {
  var token = req.body.token || req.query.token || req.headers['x-access-token']

  if (!token) {
    return res.status(403).send({
      success: false,
      message: 'No token provided'
    })
  }

  jwt.verify(token, app.get('superSecret'), function (err, decoded) {
    if (err) {
      return res.json({ success: false, message: 'Bad token' })
    }

    req.decoded = decoded
    next()
  })
})

apiRoutes.get('/', function (req, res) {
  res.json({ message: 'Welcome to the API.' })
})

apiRoutes.get('/users', function (req, res) {
  User.find({}, function (err, users) {
    res.json(users)
  })
})

app.use('/api', apiRoutes)
