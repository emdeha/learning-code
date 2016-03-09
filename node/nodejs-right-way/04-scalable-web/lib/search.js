'use strict';

const request = require('request');

module.exports = function(queryTemplate, config, app, onReceive, qs) {
  app.get(queryTemplate, function(req, res) {
    if (! /^(author|subject)$/.test(req.params.view)) {
      res.json(400, {
        error: "bad_request",
        reson: "params.view must be 'author' or 'subject'"
      });
      return;
    }

    request({
      method: 'GET',
      url: config.bookdb + '_design/books/_view/by_' + req.params.view,
      qs: qs(req)
    }, function(err, couchRes, body) {
      // couldn't connect to CouchDB
      if (err) {
        res.json(502, { error: "bad_gateway", reason: err.code });
        return;
      }
      
      // CouchDB couldn't process our request
      if (couchRes.statusCode !== 200) {
        res.json(couchRes.statusCode, JSON.parse(body));
        return;
      }

      onReceive(res, body);
    });
  });
};
