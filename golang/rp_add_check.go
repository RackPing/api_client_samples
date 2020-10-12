///bin/true; exec /usr/bin/env go run "$0" "$@"

// Program: rp_add_check.go
// Usage: go run rp_add_check.go
// Purpose: Go language sample client program for RackPing Monitoring API 2.0
// Version: 1.0
// Copyright: RackPing USA 2020
// Env: Go 1.13.14 or higher
// Returns: exit status is non-zero on failure
// Notes: first set envariables with: source ../set.sh

package main

import (
        "bytes"
        "encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
        "net/http/httputil"
	"os"
        "strconv"
	"time"
)

func debug(data []byte, err error) {
    if err == nil {
       fmt.Printf("%s\n\n", data)
    } else {
       log.Fatalf("%s\n\n", err)
    }
}

// global variables for communicating with callback redirect function redirectPolicyFunc()
var g_username string = ""
var g_password string = ""
var g_api_key  string = ""

func redirectPolicyFunc(req *http.Request, via []*http.Request) error {
   req.SetBasicAuth(g_username, g_password)
   req.Header.Set("app-key", g_api_key)
   return nil
}

func main() {
   var username string = os.Getenv("RP_USER")
   var password string = os.Getenv("RP_PASSWORD")
   var api_key  string = os.Getenv("RP_API_KEY")

   if username == "" {
      fmt.Printf("%s\n", "error: do 'source ../set.sh' first.")
      os.Exit(1)
   }

   var domain   string = os.Getenv("RP_DOMAIN")
   var base_url string = os.Getenv("RP_BASE_URL")
   var scheme   string = os.Getenv("RP_SCHEME")

   var Debug bool = (os.Getenv("RP_DEBUG") == "1")

   // see https://golang.org/pkg/time/ for how time casts work
   timeout, err := strconv.Atoi(os.Getenv("RP_TIMEOUT"))
   if err != nil {
      log.Fatal(err)
   }

   var url string = scheme + domain + base_url

   client := &http.Client{
      Timeout: time.Duration(timeout) * time.Second,
      CheckRedirect: redirectPolicyFunc,
   }

   g_username = username
   g_password = password
   g_api_key  = api_key

   {
      // if you want to understand this type definition, see the following links:
      // - https://gobyexample.com/json
      // - https://golang.org/pkg/encoding/json/#Marshal

      type RackPing struct { 
           Name       string `json:"name"`
           Host       string `json:"host"`
           Port       int    `json:"port"`
           Resolution int    `json:"resolution"`
           Paused     int    `json:"paused"`
      }

      m := RackPing{
         Name:       "APITest",
         Host:       "https://api.rackping.com/",
         Port:       443,
         Resolution: 60,
         Paused:     1 } // leave bracket on same line as last field

      b, err := json.Marshal(m)
      data := bytes.NewBuffer(b)

      println("Add one check")

      req, err := http.NewRequest("POST", url + "/checks", data)

      req.Header.Set("Content-Type", "application/json")
      req.SetBasicAuth(g_username, g_password)
      req.Header.Set("app-key", api_key)
      if Debug { debug(httputil.DumpRequestOut(req, true)) }

      res, err := client.Do(req)
      if err != nil {
         log.Fatal(err)
         debug(httputil.DumpResponse(res, true))
      } else {
         defer res.Body.Close()
         if Debug { debug(httputil.DumpResponse(res, true)) }
         body, err := ioutil.ReadAll(res.Body)
         if err == nil {
            fmt.Printf("%s\n", body)
         }
      }

      if Debug { debug(httputil.DumpResponse(res, true)) }
      println("HTTP status code is", res.StatusCode)
   }

   os.Exit(0)
}

