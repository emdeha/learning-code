var MongoClient = require('mongodb').MongoClient;
var ObjectId = require('mongodb').ObjectID;
var assert = require('assert');

var url = 'mongodb://localhost:27017/test';

var removeRestaurants = function(db, callback) {
  db.collection('restaurants').deleteMany(
    { 'borough': 'Manhattan' },
    function(err, res) {
      console.log(res);
      callback();
    });
};

MongoClient.connect(url, function(err, db) {
  assert.equal(null, err);
  removeRestaurants(db, function() {
    db.close();
  });
});
