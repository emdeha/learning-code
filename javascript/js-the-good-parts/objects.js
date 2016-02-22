// Simple objects
var empty_object = {};

var stooge = {
  "first-name": "Jerome",
  "last-name": "Howard",
  age: 28
};

document.writeln(stooge["first-name"]);
document.writeln(stooge.age);

document.writeln(stooge.work || "(none)");

// Referencing
var x = stooge;
x.nickname = 'Curly';
var nick = stooge.nickname;

document.writeln(stooge.nickname === x.nickname && x.nickname === nick);

// Prototypes
if (typeof Object.create !== 'function') {
  Object.create = function(o) {
    var F = function() {};
    F.prototype = o;
    return new F();
  };
}

var another_stooge = Object.create(stooge);
document.writeln(another_stooge.nickname);
