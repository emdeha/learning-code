/**
 * author and subject search
 * curl http://localhost:3000/api/search/author?q=Giles
 * curl http://localhost:3000/api/search/subject?q=Croc
 */
'use strict';

const
  search = require('./search.js');

module.exports = function(config, app) {  
  search('/api/search/:view', config, app,
    function(res, body) {
      // send back just the keys we got back from CouchDB
      res.json(JSON.parse(body).rows.map(function(elem){
        return elem.key;
      }));
    }, function(req) {
      return {
        startkey: JSON.stringify(req.query.q),  
        endkey: JSON.stringify(req.query.q + "\ufff0"),
        group: true
      };
    });
}
