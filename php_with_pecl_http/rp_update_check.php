#!/usr/bin/php
<?php
// Program: rp_update_check.php
// Usage: ./rp_update_check.php
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

   $ret = 0;

   fwrite(STDERR, "Update one check" . PHP_EOL);

   $data = array(
      "name"       => "APITestTest",
      "host"       => "https://www.rackping.com/",
      "port"       => 443,
      "resolution" => 60,
      "paused"     => 1
   );

   $json_data = json_encode($data);

   $http_req = new HttpRequest($url . '/checks/' . $id, HttpRequest::METH_PUT);

   $headers = array(
      'App-key'       => $api_key,
      'Authorization' => "Basic " . base64_encode("$user:$password"),
      'Content-type'  => 'application/json'
   );

   $http_req->setHeaders($headers);

   $http_req->setOptions(array('timeout'   => $timeout,
                               'useragent' => $useragent,
                               'redirect'  => $redirects
   ));

   $http_req->setBody($json_data);

   try {
       $http_req->send();
       if ($http_req->getResponseCode() == 200) {
           echo $http_req->getResponseBody();
       }
       else {
           echo $http_req->getRawResponseMessage();
       }
   } catch (HttpException $ex) {
       echo $ex;
       exit(1);
   }

   exit($ret);
?>
