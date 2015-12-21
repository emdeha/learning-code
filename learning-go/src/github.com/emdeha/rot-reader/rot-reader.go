package main

import (
//  "fmt"
  "io"
  "os"
  "strings"
)

type rot13Reader struct {
  r io.Reader
}

func (rot13 rot13Reader) Read(b []byte) (int, error) {
  str := make([]byte, len(b))
  n, _ := rot13.r.Read(str)

  for i:=0; i < n; i++ {
    if str[i] != ' ' {
      b[i] += str[i] - 13
    } else {
      b[i] = ' '
    }
  }

  return n, io.EOF
}

func main() {
  s := strings.NewReader("Lbh penpxrq gur pbqr!")
  r := rot13Reader{s}
  io.Copy(os.Stdout, &r)
}
