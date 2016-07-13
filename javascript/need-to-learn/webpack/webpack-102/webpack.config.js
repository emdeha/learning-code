var path = require('path')

module.exports = {
  entry: './src',
  resolve: {
    root: [path.join(__dirname, 'src/'), path.join(__dirname, 'node_modules/')]
  },
  output: {
    path: './dst',
    filename: 'bundle.js'
  },
  module: {
    loaders: [
      { test: /\.js$/, loaders: ['babel'] }
    ]
  }
}
