var MongoClient = require('mongodb').MongoClient;
var ObjectId = require('mongodb').ObjectID;
var assert = require('assert');

var url = 'mongodb://localhost:27017/test';

var findRestaurants = function(db, callback) {
  var cursor = db.collection('restaurants').find( {
      'borough': 'Manhattan',
      'address.zipcode': '10025'
    }).sort({
      'borough': 1,
      'address.zipcode': -1
    });
  cursor.each(function(err, doc) {
    assert.equal(null, err);
    if (doc != null) {
      console.dir(doc);
    } else {
      callback();
    }
  });
};

MongoClient.connect(url, function(err, db) {
  assert.equal(null, err);
  findRestaurants(db, function() {
    db.close();
  });
});
