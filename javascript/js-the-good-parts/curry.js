Function.prototype.method = function (name, func) {
  if (!this.prototype[name]) {
    this.prototype[name] = func;
  }
  return this;
};

Function.method('curry', function () {
  var slice = Array.prototype.slice,
      args = slice.apply(arguments),
      that = this;

  return function () {
    return that.apply(null, args.concat(slice.apply(arguments)));
  };
});

var add = function (a, b) {
  return a + b;
};

var add1 = add.curry(1);
document.writeln(add1(2)); // 3
document.writeln(add1(10)); // 11
