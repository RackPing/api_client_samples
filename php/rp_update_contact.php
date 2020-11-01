#!/usr/bin/php
<?php
// Program: rp_update_contact.php
// Usage: ./rp_update_contact.php
// Date: 2020 10 07
// Purpose: php language sample client program for RackPing Monitoring API 2.0
// Version: 1.0
// Copyright: RackPing USA 2020
// Env: PHP5 or newer
// Returns: exit status is non-zero on failure
// Note: first do: source ../set.sh

   error_reporting(E_ALL);

   $url      = getenv('RP_SCHEME') . getenv('RP_DOMAIN') . getenv('RP_BASE_URL');
   $api_key  = getenv('RP_API_KEY');
   $user     = getenv('RP_USER');
   $password = getenv('RP_PASSWORD');
   $timeout  = getenv('RP_TIMEOUT');
   $debug    = getenv('RP_DEBUG');

   if (empty($api_key)) {
      echo "error: do source ../set.sh to set the envariables.\n";
      exit(1);
   }

function http_parse_headers($header) {
// http://php.net/manual/it/function.http-parse-headers.php by Anon

   $retVal = array();
   $fields = explode("\r\n", preg_replace('/\x0D\x0A[\x09\x20]+/', ' ', $header));
   foreach( $fields as $field ) {
      if (preg_match('/([^:]+): (.+)/m', $field, $match)) {
         $match[1] = preg_replace('/(?<=^|[\x09\x20\x2D])./e', 'strtoupper("\0")', strtolower(trim($match[1])));
         if (isset($retVal[$match[1]]) ) {
            if (!is_array($retVal[$match[1]])) {
               $retVal[$match[1]] = array($retVal[$match[1]]);
            }
            $retVal[$match[1]][] = $match[2];
         } else {
            $retVal[$match[1]] = trim($match[2]);
         }
      }
   }
   return $retVal;
}

function do_curl($method, $endpoint, $user, $pw, $api_key, $timeout, $data) {
   // echo "method=$method, url=$endpoint, data=$data\n";

   $headers = array(
      'Content-Type: application/json',
      'Authorization: Basic '. base64_encode("$user:$pw"),
      'Accept: application/json',
      'Accept-Charset: utf-8',
      "App-key: $api_key"
   );

   $ch = curl_init();

   curl_setopt($ch, CURLOPT_URL, $endpoint);
   curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
   curl_setopt($ch, CURLOPT_TIMEOUT, $timeout);
   curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
   curl_setopt($ch, CURLOPT_HEADER, 1);

   $redirects = getenv('RP_REDIRECTS');
   if ($redirects) {
      curl_setopt($curl, CURLOPT_FOLLOWLOCATION, true);
      curl_setopt($curl, CURLOPT_POSTREDIR, 3);
   }
   else {
      curl_setopt($curl, CURLOPT_FOLLOWLOCATION, false);
   }

   if ($method == 'POST' or $method == 'PUT' or $method == 'DELETE') {
      curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);

      // for HTML form POST data:
      // curl_setopt($ch, CURLOPT_POSTFIELDS,http_build_query($data));

      // for JSON data:
      $json_data = json_encode($data);
      curl_setopt($ch, CURLOPT_POSTFIELDS, $json_data);
   }

   $response = curl_exec($ch);
   $info = curl_getinfo($ch);
   $header_size = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
   curl_close($ch);  

   $headers = substr($response, 0, $header_size);
   $body = substr($response, $header_size);

   $info['headers'] = http_parse_headers($headers);
   $info['body'] = $body;

   return $info;
}

   $id = $argv[1];

   if (empty($id)) {
      echo "usage: ./$argv[0] contactid\n";
      exit(1);
   }

   $ret = 0;

   fwrite(STDERR, "Update one contact" . PHP_EOL);

   $data = array(
      "first"        => "JohnJohn",
      "last"         => "Doe",
      "email"        => "john.doe+" + $api_key . "@example.com",
      "role"         => "O",
      "cellphone"    => "408 555 1212",
      "countrycode"  => 1,
      "countryiso"   => "US",
   );

   $response = do_curl('PUT', $url . '/contacts/' . $id, $user, $password, $api_key, $timeout, $data);
   $rc = $response['http_code'];

   # fwrite(STDERR, var_dump($response) . PHP_EOL);

   if ($rc == '200') {
      fwrite(STDERR, "OK ($rc) - " . PHP_EOL);
   }
   else {
      fwrite(STDERR, "ERROR ($rc) - " . PHP_EOL);
      $ret++;
   }

   echo $response['body'];
   # fwrite(STDERR, var_dump($response) . PHP_EOL);
   echo "\n";

   exit($ret);
?>
