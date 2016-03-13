var MongoClient = require('mongodb').MongoClient;
var ObjectId = require('mongodb').ObjectID;
var assert = require('assert');

var url = 'mongodb://localhost:27017/test';

var updateRestaurants = function(db, callback) {
  db.collection('restaurants').findOne({'name': 'Juni'}, 
    function(err, doc) {
      console.log(doc)
    });

  db.collection('restaurants').updateOne(
    { 'name': 'Juni' },
    { 
      $set: {'cuisine': 'American'},
      $currentDate: { 'lastModified': true }
    }, function(err, res) {
      console.log(res);
      callback();
    });
};

MongoClient.connect(url, function(err, db) {
  assert.equal(null, err);
  updateRestaurants(db, function() {
    db.close();
  });
});
