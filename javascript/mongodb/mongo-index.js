var MongoClient = require('mongodb').MongoClient;
var ObjectId = require('mongodb').ObjectID;
var assert = require('assert');

var url = 'mongodb://localhost:27017/test';

var indexRestaurants = function(db, callback) {
  db.collection('restaurants').createIndex(
    { 'cuisine': 1 },
    null,
    function(err, res) {
      console.log(res);
      callback();
    });
};

var compoundIndexRestaurants = function(db, callback) {
  db.collection('restaurants').createIndex(
    { 'cuisine': 1, 'address.zipcode': -1 },
    null,
    function(err, res) {
      console.log(res);
      callback();
    });
};

MongoClient.connect(url, function(err, db) {
  assert.equal(null, err);
  compoundIndexRestaurants(db, function() {
    db.close();
  });
});
