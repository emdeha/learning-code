#!/bin/bash

set -e

file_pattern=$1

function main {
  for rev in `list_revisions`; do
    echo "`number_of_lines` `commit_message`"
  done
}

function commit_message {
  git log --oneline -1 $rev
}

function number_of_lines {
  git ls-tree --full-tree -r $rev |
  grep "blob" |
  grep "$file_pattern" |
  awk '{print $3}' |
  xargs git show |
  wc -l
}

function list_revisions {
  git rev-list --reverse HEAD 
}

main
