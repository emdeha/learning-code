'use strict';

const
  file = require('file'),
  rdfParser = require('./lib/rdf-parser.js');

console.log('beginning directory walk');

rdfParser(__dirname + '/test/pg132.rdf', function(err, doc) {
  if (err) {
    throw err;
  } else {
    console.log(doc);
  }
});
