numbers = [ 'zero', 'one', 'two' ];
numbers.push('shi');
numbers.push('go');

document.writeln(numbers);

// Deletes some elements; other arguments specify what to replace with
japNums = numbers.splice(3, 2);
document.writeln(japNums);

// Iteration by order
var i;
for (i = 0; i < numbers.length; i += 1) {
  document.writeln(numbers[i]);
}

// Adds methods
Function.prototype.method = function (name, func) {
  if (!this.prototype[name]) {
    this.prototype[name] = func;
  }
  return this;
}

Array.method('reduce', function (f, value) {
  var i;
  for (i = 0; i < this.length; i += 1) {
    value = f(this[i], value);
  }
  return value;
});

var data = [4, 8, 15, 16, 23, 42];

var add = function(a, b) {
  return a + b;
};

document.writeln(data.reduce(add, 0));

data.total = function () {
  return this.reduce(add, 0);
};

document.writeln(data.total());
