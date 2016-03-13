var MongoClient = require('mongodb').MongoClient;
var ObjectId = require('mongodb').ObjectID;
var assert = require('assert');

var url = 'mongodb://localhost:27017/test';

var aggregateRestaurants = function(db, callback) {
  db.collection('restaurants').aggregate(
    [ { $group: {'_id': '$borough', 'count': { $sum: 1 } } } ]
  ).toArray(function(err, result) {
    assert.equal(err, null);
    console.log(result);
    callback()
  })
};

var filterAndGroupRestaurants = function(db, callback) {
  db.collection('restaurants').aggregate([
    { $match: { 'borough': 'Queens', 'cuisine': 'Brazilian' } },
    { $group: { '_id': '$address.zipcode', 'count': { $sum: 1 } } }
  ]).toArray(function(err, res) {
    assert.equal(null, err);
    console.log(res);
    callback();
  })
};

MongoClient.connect(url, function(err, db) {
  assert.equal(null, err);
  filterAndGroupRestaurants(db, function() {
    db.close();
  });
});
