// Uses fundamental to do a memoizable computation.
// Begins from an initial memo state.
var memoizer = function (memo, fundamental) {
  var shell = function (n) {
    var result = memo[n];
    if (typeof result !== 'number') {
      result = fundamental(shell, n);
      memo[n] = result;
    }

    return result;
  };

  return shell;
};

var fib = memoizer([0, 1], function (shell, n) {
  return shell(n - 1) + shell(n - 2);
});

document.writeln(fib(10));

var fact = memoizer([1, 1], function (shell, n) {
  return n * shell(n - 1);
});

document.writeln(fact(5));
