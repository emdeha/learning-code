// Hidden value
var myObject = function () {
  var value = 0;

  return {
    increment: function (inc) {
      value += typeof inc === 'number' ? inc : 1;
    },
    getValue: function () {
      return value;
    }
  };
}();

document.writeln(myObject.getValue()); // 0

myObject.increment();
document.writeln(myObject.getValue()); // 1

myObject.increment(4);
document.writeln(myObject.getValue()); // 5

// Set DOM node's color to yellow then fade to white
var fade = function (node) {
  var level = 16;

  var step = function () {
    var hex = level.toString(16);
    node.style.backgroundColor = '#FFFF' + hex + hex;
    if (level > 0) {
      level -= 1;
      setTimeout(step, 100);
    }
  };

  setTimeout(step, 100);
};

fade(document.body);
