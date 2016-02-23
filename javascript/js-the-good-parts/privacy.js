// Create parent
var mammal = function (spec) {
  var that = {};

  that.get_name = function () {
    return spec.name;
  };

  that.says = function () {
    return spec.saying || '';
  };

  return that;
};

var myMammal = mammal({ name: 'Herb' });


// Create child; inherits
var cat = function (spec) {
  spec.saying = spec.saying || 'meow';

  var that = mammal(spec);

  that.purr = function () {
    return 'r-r-r-r';
  };

  that.get_name = function () {
    return that.says() + ' ' + spec.name + ' ' + that.says();
  };

  return that;
}

var myCat = cat({ name: 'Henrietta' });


// Implementing super
Function.prototype.method = function (name, func) {
  // Add method only if it's missing
  if (!this.prototype[name]) {
    this.prototype[name] = func;
  }
  return this;
};

Object.method('superior', function (name) {
  var that = this,
      method = that[name];
  return function () {
    return method.apply(that, arguments);
  };
});

var coolcat = function (spec) {
  var that = cat(spec), // inherit
      super_get_name = that.superior('get_name'); // use the parent's get_name

  that.get_name = function (n) {
    return 'like ' + super_get_name() + ' baby';
  };

  return that;
};

var myCoolCat = coolcat({ name: 'Bix' });
document.writeln(myCoolCat.get_name());
