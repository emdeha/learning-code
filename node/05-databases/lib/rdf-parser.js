'use strict';

const
  fs = require('fs'),
  cheerio = require('cheerio');

module.exports = function(filename, callback) {
  fs.readFile(filename, function(err, data) {
    if (err) {
      return callback(err);
    }

    let
      $ = cheerio.load(data.toString()),
      collect = function(index, elem) {
        return $(elem).text();
      },
      authors = [],
      names = {},
      subjects = [],
      values = {};

    names = $('pgterms\\:agent pgterms\\:name').map(collect);
    for (var i in names) {
      if (!isNaN(parseFloat(i)) && isFinite(i)) {
        authors.push(names[i]);
      }
    }

    values = $('dcterms\\:subject rdf\\:value').map(collect);
    for (var i in values) {
      if (!isNaN(parseFloat(i)) && isFinite(i)) {
        subjects.push(values[i]);
      }
    }

    callback(null, {
      _id: $('pgterms\\:ebook').attr('rdf:about').replace('ebooks/', ''), 
      title: $('dcterms\\:title').text(), 
      authors: authors,
      subjects: subjects  
    });
  });
};
