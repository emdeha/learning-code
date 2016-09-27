var fs = require('fs');

function someAsyncOperation (callback) {
  // Assume this takes 95ms to complete
  fs.readFile('./event-loop.js', callback);
}

var timeoutScheduled = Date.now();

setTimeout(function () {

  var delay = Date.now() - timeoutScheduled;

  console.log(delay + "ms have passed since I was scheduled");
}, 100);


// do someAsyncOperation which takes 95 ms to complete
someAsyncOperation(function () {

  var startCallback = Date.now();

  // do something that will take 10ms...
  while (Date.now() - startCallback < 10) {
    ; // do nothing
  }

});
