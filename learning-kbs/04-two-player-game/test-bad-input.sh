#!/bin/bash

function test {
  exp=$@
  res=$(eval "$exp 2>&1")
  echo "$exp : $res"
}

test ./tic-tac-toe "'O        '"
test ./tic-tac-toe "'         '"
test ./tic-tac-toe "'    X    '"
test ./tic-tac-toe "'O   X    '"
test ./tic-tac-toe "'        X'"
test ./tic-tac-toe "'        O'"
test ./tic-tac-toe "'O       '"
test ./tic-tac-toe "'       '"
test ./tic-tac-toe "' X     '"
test ./tic-tac-toe "' X        '"
test ./tic-tac-toe "' O        '"
test ./tic-tac-toe "''"
test ./tic-tac-toe
