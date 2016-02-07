package main

import (
  "log"
  "net/http"
  "fmt"
)

type String string

type Struct struct {
  Greeting string
  Punct    string
  Who      string
}

func (str String) ServeHTTP(rw http.ResponseWriter, rq *http.Request) {
  fmt.Fprint(rw, str)
}

func (greet Struct) ServeHTTP(rw http.ResponseWriter, rq *http.Request) {
  fmt.Fprintf(rw, "%v%v %v", greet.Greeting, greet.Punct, greet.Who)
}

func main() {
  // your http.Handle calls here
  http.Handle("/string", String("I'm a fried knot."))
  http.Handle("/struct", Struct{"Hello", ":", "Jelaine!"})
  log.Fatal(http.ListenAndServe("localhost:4000", nil))
}

