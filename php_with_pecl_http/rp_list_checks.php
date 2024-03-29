#!/usr/bin/php
<?php
// Program: rp_list_checks.php
// Usage: ./rp_list_checks.php
// Date: 2020 10 07
// Purpose: php language sample client program for RackPing Monitoring API 2.0
// Version: 1.0
// Copyright: RackPing USA 2020
// Env: PHP5 with pecl_http or newer
// Returns: exit status is non-zero on failure
// Note: first do: source ../set.sh
// See http://www.mkfoster.com/2009/01/04/how-to-use-the-pecl-http-pecl_http-extension-to-make-http-requests-from-php/

   error_reporting(E_ALL);

   $url       = getenv('RP_SCHEME') . getenv('RP_DOMAIN') . getenv('RP_BASE_URL');
   $api_key   = getenv('RP_API_KEY');
   $user      = getenv('RP_USER');
   $password  = getenv('RP_PASSWORD');
   $timeout   = getenv('RP_TIMEOUT');
   $redirects = getenv('RP_REDIRECTS');
   $useragent = getenv('RP_USERAGENT');
   $debug     = getenv('RP_DEBUG');

   if (empty($api_key)) {
      echo "error: do source ../set.sh to set the envariables.\n";
      exit(1);
   }

   fwrite(STDERR, "Get list of checks\n");

   $http_req = new HttpRequest($url . '/checks');

   $headers = array(
     'App-key' => $api_key,
     'Authorization' => "Basic " . base64_encode("$user:$password"),
     'Accept'        => 'application/json',
     'Accept-Charset' => 'utf-8'
   );

   $http_req->setHeaders($headers);

   $http_req->setOptions(array('timeout'   => $timeout,
                               'useragent' => $useragent,
                               'redirect'  => $redirects
   ));

   $ret = 0;

   try {
       $http_req->send();
       if ($http_req->getResponseCode() == 200) {
           echo $http_req->getResponseBody();
       }
       else {
           if ($debug) {
              echo $http_req->getRawResponseMessage();
           }
           echo "HTTP response code: " . $http_req->getResponseCode() . "\n";
           exit(1);
       }
   } catch (HttpException $ex) {
       echo $ex;
       exit(1);
   }

   exit($ret);
?>
