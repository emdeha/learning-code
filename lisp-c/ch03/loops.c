#include <stdio.h>

void outputNTimes(int n) {
  for (int i = 0; i < n; i++) {
    puts("Hello world!");
  }
}

int main(int argc, char **argv) {
  puts("--- a for loop ---");
  for (int i = 0; i < 5; i++) {
    puts("Hello world!");
  }

  puts("\n--- a while loop ---");
  int i = 0;
  while (i < 5) {
    puts("Hello world!");
    i++;
  }

  puts("\n--- a function ---");
  outputNTimes(5);

  return 0;
}
