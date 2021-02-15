#!/usr/bin/env node

// Program: rp_add_contact.js
// Usage: ./rp_add_contact.js
// Purpose: node.js language sample client program for RackPing Monitoring API 2.0
// Date: 2021 02 12
// Version: 1.0
// Copyright: RackPing USA 2020
// Env: Perl5
// Returns: exit status is non-zero on failure
// Note: First set the envariables with: source ../set.sh

const https = require("https");

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

   var pw = '';
   for (i = 1; i <= 10; i++) {                   // sample code to assign a random password (in plaintext for password reminder email)
       pw += between(0, 15).toString(16);
   }

const data = JSON.stringify({
   'first':       'John',
   'last':        'Doe',
   'email':       'john.doe+' + api_key + '@example.com',
   'role':        'O',                           // user role: A = Admin, O = Operator, B = Billing
   'cellphone':   '408 555 1212',
   'countrycode': '1',                           // numeric telephone country code prefix
   'countryiso':  'US',                          // 2-letter country ISO code
   'lang':         'en',                         // language for new user and password reminder email
   'timezone':     'America/New_York',
   'sendemail':    '0',                          // send password reminder email [0|1]
   'alertable':    'N',                          // enable paid AlertPro user [Y|N]
   'pw':           pw                            // user password. blank disables password reminder email.
});

// end of user settings

   const options = {
       "method": "POST",
       "hostname": host,
       "port": 443,
       "path": base_url + "/contacts",
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

   console.error("info: add one contact:");

   const req = https.request(options, function(res) {
       var chunks = [];

       res.on("data", function (chunk) {
           chunks.push(chunk);
       });

       res.on("end", function() {
           if (res.statusCode != 200) {
              console.log("error: status code", res.statusCode);
              process.exit(1);
           }

           var body = Buffer.concat(chunks);
           console.log(body.toString());
       });
   });

   req.write(data)
   req.end();

function between(min, max) {  
  return Math.floor(
    Math.random() * (max - min) + min
  )
}
