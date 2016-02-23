// Add new methods with `Object.method` instead of `Object.prototype.method`
Function.prototype.method = function (name, func) {
  // Add method only if it's missing
  if (!this.prototype[name]) {
    this.prototype[name] = func;
  }
  return this;
};

// Add `integer` method to Number
Number.method('integer', function () {
  return Math[this < 0 ? 'ceil' : 'floor'](this);
});

document.writeln((-10 / 3).integer());

// Add `trim` method to String
String.method('trim', function () {
  return this.replace(/^\s+|\s+$/g, '');
});

document.writeln('"' + " neat   ".trim() + '"');
