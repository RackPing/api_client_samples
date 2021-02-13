#!/usr/bin/env node

// Program: rp_resume_check.js
// Usage: ./rp_resume_check.js
// Purpose: node.js language sample client program for RackPing Monitoring API 2.0
// Date: 2021 02 12
// Version: 1.0
// Copyright: RackPing USA 2020
// Env: Perl5
// Returns: exit status is non-zero on failure
// Note: First set the envariables with: source ../set.sh

const https = require("https");

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

   const options = {
       "method": "PUT",
       "hostname": host,
       "port": 443,
       "path": base_url + "/checks/" + id + '?paused=0',
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

   console.error("info: resume one check:");

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

   req.end();

