// Mammal object
var Mammal = function (name) {
  this.name = name;
};

Mammal.prototype.get_name = function () {
  return this.name;
};

Mammal.prototype.says = function () {
  return this.saying || '';
};

var myMammal = new Mammal('Herb the Mammal');
document.writeln(myMammal.get_name());

// Cat object, inherits from Mammal
var Cat = function (name) {
  this.name = name;
  this.saying = 'meow';
};

Cat.prototype = new Mammal();

// Augment the new prototype
Cat.prototype.purr = function (n) {
  var i, s = '';
  for (i = 0; i < n; i += 1) {
    if (s) {
      s += '-';
    }
    s += 'r';
  }
  return s;
};

// Overload get_name?
Cat.prototype.get_name = function () {
  return this.says() + ' ' + this.name + ' ' + this.says();
};

var myCat = new Cat('Henrietta'); // She's a mean go-getter \ Gonna write her a letter
document.writeln(myCat.says());
document.writeln(myCat.purr(5));
document.writeln(myCat.get_name());
