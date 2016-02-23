// Prototypal inheritance
var myMammal = {
  name: 'Herb the Mammal',
  get_name: function () {
    return this.name;
  },
  says: function () {
    return this.saying || '';
  }
};


// inherit everything from myMammal
var myCat = Object.create(myMammal);

// differentiate it
myCat.name = 'Henrietta';
myCat.saying = 'meow';

myCat.purr = function (n) {
  return 'r-r-r-r';
};

myCat.get_name = function () {
  return this.says() + ' ' + this.name + ' ' + this.says();
};

document.writeln(myCat.get_name());
document.writeln(myCat.says());
document.writeln(myCat.purr());
