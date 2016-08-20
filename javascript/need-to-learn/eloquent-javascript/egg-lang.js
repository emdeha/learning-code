/*
 * The Egg language constitutes of words, values and applications.
 *
 * words have names, which are bound to program constructs. The names can be
 * any character except \s, (, ), [,], ".
 *
 * values can be either strings or digits. String values can be any character
 * except ". Digit values have one or more digits.
 *
 * applications have operator that refers to the expression being applied and
 * args that refer to the arguments that this expression operates upon
 *
 * The following is an example Egg program.
 */
var testExpr = 
  'do(define(x, 10),' +
    'if(>(x, 5),' +
      'print("large"),' +
      'print("small")))'


/*
 * The parser creates the following structure from an egg program:
 * {
 *   type: <expr_type>,
 *   operator: { type: <op_type>, name: <op_name> },
 *   args: [
 *     { type: 'word', name: <word_name> },
 *     { type: 'value', value: <value> }
 *   ]
 * }
 */
var skipSpace = function (str) {
  var idx = str.search(/\S/)
  if (idx === -1) return ''
  return str.slice(idx)
}

function parseApply(expr, program) {
  program = skipSpace(program)
  if (program[0] !== '(') {
    return { tree: expr, rest: program }
  }

  program = skipSpace(program.slice(1))
  expr = { type: 'apply', operator: expr, args: [] }
  while (program[0] !== ')') {
    var arg = parseExpression(program)
    expr.args.push(arg.tree)
    program = skipSpace(arg.rest)
    if (program[0] === ',') {
      program = skipSpace(program.slice(1))
    } else if (program[0] !== ')') {
      throw new SyntaxError("Expected ',' or ')'")
    }
  }
  return parseApply(expr, program.slice(1))
}

function parseExpression(program) {
  program = skipSpace(program)
  var match
  var expr
  if (match = /^"([^"]*)"/.exec(program)) {
    expr = { type: 'value', value: match[1] }
  } else if (match = /^\d+\b/.exec(program)) {
    expr = { type: 'value', value: Number(match[0]) }
  } else if (match = /^[^\s(),"]+/.exec(program)) {
    expr = { type: 'word', name: match[0] }
  } else {
    throw new SyntaxError("Unexpected syntax: " + program)
  }

  return parseApply(expr, program.slice(match[0].length))
}

var parser = function (program) {
  var parsed = parseExpression(program)
  if (skipSpace(parsed.rest).length > 0) {
    throw new SyntaxError('Unexpected text after program')
  }
  return parsed.tree
}

console.log(parser(testExpr))
