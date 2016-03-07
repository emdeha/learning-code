'use strict';

const
  zmq = require('zmq'),
  subscriber = zmq.socket('sub');

subscriber.connect('tcp://localhost:9889');
subscriber.subscribe('');

subscriber.on("message", function(data) {
  let
    message = JSON.parse(data),
    date = new Date(message.timestamp);

  console.log("File '" + message.file + "' changed at " + date);
});
