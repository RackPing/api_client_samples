///bin/true; exec /usr/bin/env go run "$0" "$@"

// Program: rp_schedule_maint.go
// Usage: go run rp_schedule_maint.go id 'start' 'end'
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
        "strings"
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
      if (len(os.Args) < 4) {
         fmt.Fprintf(os.Stderr, "usage: %s id 'start' 'end'\n", os.Args[0])
         os.Exit(1)
      }

      id    := os.Args[1]
      start := strings.Replace(os.Args[2], " ", "%20", 1) 
      end   := strings.Replace(os.Args[3], " ", "%20", 1) 

      fmt.Printf("%s\n", "Enable maintenance window for one check")

      req, err := http.NewRequest("PUT", url + "/checks/" + id + "?start_maintenance=" + start + "&end_maintenance=" + end, nil)
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
   }

   os.Exit(0)
}

