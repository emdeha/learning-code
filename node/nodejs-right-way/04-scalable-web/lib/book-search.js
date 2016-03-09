/**
 * search for books by a given field (author or subject)
 * curl http://localhost:3000/api/search/book/by_author?q=Giles,%20Lionel
 * curl http://localhost:3000/api/search/book/by_subject?q=War
 */
'use strict';

const 
  search = require('./search.js');

module.exports = function(config, app) {
  search('/api/search/book/by_:view', config, app,
    function(res, body) {
      // send back simplified documents we got from CouchDB
      let books = {};
      JSON.parse(body).rows.forEach(function(elem){
        books[elem.doc._id] = elem.doc.title;
      });

      res.json(books);
    }, function(req) {
      return {
        key: JSON.stringify(req.query.q),
        reduce: false,
        include_docs: true
      };
    });
};
