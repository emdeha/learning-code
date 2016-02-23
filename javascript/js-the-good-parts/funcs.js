// Invocation
// Method
var myObject = {
  value: 0,
  increment: function (inc) {
    this.value += typeof inc === 'number' ? inc : 1;
  }
};

myObject.increment();
document.writeln(myObject.value);

myObject.increment(2);
document.writeln(myObject.value);

// Function
myObject.doble = function () {
  var that = this; // We don't want global `this` when we call a function

  var helper = function() {
    that.value = that.value + that.value;
  };

  helper();
};

myObject.doble();
document.writeln(myObject.value);

// Constructor
var Quo = function (string) {
  this.status = string;
};

Quo.prototype.getStatus = function() {
  return this.status;
};

var myQuo = new Quo("confused");
document.writeln(myQuo.getStatus());

// Apply
var add = function (a, b) { return a + b; };

var array = [3, 4];
var sum = add.apply(null, array);

document.writeln(sum);

var statusObject = {
  status: 'A-OK'
};

// apply binds `this` to the provided first parameter
var status = Quo.prototype.getStatus.apply(statusObject);
document.writeln(status);

// Use `arguments`
var sum = function () {
  var i, sum = 0;
  for (i = 0; i < arguments.length; i += 1) {
    sum += arguments[i];
  }
  return sum;
}

document.writeln(sum(1, 2, 3, 4, 5));
