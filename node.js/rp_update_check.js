#!/usr/bin/env node

// Program: rp_update_check.js
// Usage: ./rp_update_check.js
// Purpose: node.js language sample client program for RackPing Monitoring API 2.0
// Version: 1.0
// Copyright: RackPing USA 2020
// Env: Perl5
// Returns: exit status is non-zero on failure
// Note: First set the envariables with: source ../set.sh

const https = require("https");
const util = require("util");

   if (process.argv.length < 3) {
      console.log("usage: %s id", process.argv[1]);
      process.exit(1);
   }

   var id = process.argv[2];

   var api_key  = process.env.RP_API_KEY;
   if (api_key == "") {
      console.log("error: do source ../set.sh first");
      process.exit(1);
   }

   var host      = process.env.RP_DOMAIN;
   var base_url  = process.env.RP_BASE_URL;
   var user      = process.env.RP_USER;
   var password  = process.env.RP_PASSWORD;
   var timeout   = process.env.RP_TIMEOUT * 1000;
   var redirects = process.env.RP_REDIRECTS;
   var useragent = process.env.RP_USERAGENT;
   var debug     = process.env.RP_DEBUG;

// start of user settings

const data = JSON.stringify({
   'name':       'APITestTest',
   'host':       'https://www.rackping.com/?' + api_key,
   'port':       443,
   'resolution': 60,
   'paused':     1
});

// end of user settings

   const options = {
       "method": "PUT",
       "hostname": host,
       "port": 443,
       "path": base_url + "/checks/" + id,
       "timeout": timeout,
//     "redirects": redirects,
       "user-agent": useragent,
       "headers": {
           "Accept":         "application/json",
           "Accept-Charset": "utf-8",
           "Content-type":   "application/json",
           "app-key":        api_key,
           "cache-control":  "no-cache",
           'Authorization':  'Basic ' + new Buffer(user + ':' + password).toString('base64')
       }
   }

   console.error("info: update one check:");

   const req = https.request(options, function(res) {
       var chunks = [];

       res.on("data", function (chunk) {
           chunks.push(chunk);
       });

       res.on("end", function() {
           var body = Buffer.concat(chunks);
           console.log(body.toString());
       });
   });

   req.write(data)
   req.end();

