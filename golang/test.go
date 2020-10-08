package main

 import (
    "os"
    "fmt"
 )

 func main() {
    fmt.Fprintf(os.Stderr, "your own program name is %s \n", os.Args[0])

 }
