'use strict';

const
  async = require('async'),
  file = require('file'),
  rdfParser = require('./lib/rdf-parser.js'),

  work = async.queue(function(path, done) {
    rdfParser(path, function(err, doc) {
      console.log(doc);
      done();
    });
  }, 1000);

console.log('begin dir walk');

file.walk(__dirname + '/cache/epub', function(err, dirPath, dirs, files) {
  files.forEach(function(path) {
    work.push(path);
  });
});
