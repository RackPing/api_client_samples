#!/usr/bin/php
<?php
// Program: rp_resume_maint.php
// Usage: ./rp_resume_maint.php
// Date: 2020 10 07
// Purpose: php language sample client program for RackPing Monitoring API 2.0
// Version: 1.0
// Copyright: RackPing USA 2020
// Env: PHP5 with pecl_http or newer
// Returns: exit status is non-zero on failure
// Note: first do: source ../set.sh

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

   $id = $argv[1];

   if (empty($id)) {
      echo "usage: ./$argv[0] checkid\n";
      exit(1);
   }

   fwrite(STDERR, "Disable maintenance for one check" . PHP_EOL);

   $http_req = new HttpRequest($url . '/checks/' . $id . '?maintenance=0', HttpRequest::METH_POST);

   $headers = array(
      'App-key'       => $api_key,
      'Authorization' => "Basic " . base64_encode("$user:$password"),
      'Accept'        => 'application/json',
      'Accept-Charset' => 'utf-8',
      'X-HTTP-Method-Override' => 'PUT'
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
