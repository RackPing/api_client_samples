///bin/true; exec /usr/bin/env go run "$0" "$@"

// Program: rp_list_checks.go
// Usage: go run rp_list_checks.go
// Purpose: Go language sample client program for RackPing Monitoring API 2.0
// Version: 1.0
// Copyright: RackPing USA 2020
// Env: Go 1.13.14 or higher
// Returns: exit status is non-zero on failure
// Notes: first set envariables with: source ../set.sh

package main

import (
//      "bytes"
//      "encoding/json"
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
   g_username = os.Getenv("RP_USER")
   g_password = os.Getenv("RP_PASSWORD")
   g_api_key  = os.Getenv("RP_API_KEY")

   if g_username == "" {
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

   {
      fmt.Printf("%s\n", "Get list of checks")

      req, err := http.NewRequest("GET", url + "/checks", nil)
      req.SetBasicAuth(g_username, g_password)
      req.Header.Set("app-key", g_api_key)

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
   }

   os.Exit(0)
}

