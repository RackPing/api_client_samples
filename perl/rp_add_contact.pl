#!/usr/bin/perl

# Program: rp_add_contact.pl
# Usage: ./rp_add_contact.pl
# Purpose: perl language sample client program for RackPing Monitoring API 2.0
# Version: 1.0
# Copyright: RackPing USA 2020
# Env: Perl5
# Returns: exit status is non-zero on failure
# Note: First set the envariables with: source ../set.sh

use strict;
use diagnostics;

use MIME::Base64 qw(encode_base64);
use LWP::UserAgent;

   use constant TIMEOUT_SEC => 5.0;

   my $url = $ENV{'RP_SCHEME'} . $ENV{'RP_DOMAIN'} . $ENV{'RP_BASE_URL'};

   my $api_key       = $ENV{'RP_API_KEY'}  // '';
   my $user          = $ENV{'RP_USER'}     // '';
   my $password      = $ENV{'RP_PASSWORD'} // '';
   my $timeout       = $ENV{'RP_TIMEOUT'}  || TIMEOUT_SEC;
   my $max_redirects = $ENV{'RP_REDIRECTS'} || 3;
   my $useragent     = $ENV{'RP_USERAGENT'} // '';
   my $DEBUG         = $ENV{'RP_DEBUG'}    || 0;

   if ($api_key eq '') {
      print "error: do source ../set.sh to set the envariables.\n";
      exit 1;
   }

### start of user settings

   my $first        = 'John';
   my $last         = 'Doe';
   my $email        = 'john.doe+' . $api_key . '@example.com';
   my $role         = 'O';                          # user role: A = Admin, O = Operator, B = Billing
   my $cellphone    = '408 555 1212';
   my $countrycode  = '1';                          # numeric telephone country code prefix
   my $countryiso   = 'US';                         # 2-letter country ISO code
   my $lang         = 'en';                         # language for new user and password reminder email
   my $timezone     = 'America/New_York';
   my $sendemail    = 0;                            # send password reminder email [0|1]
   my $alertable    = 'N';                          # enable paid AlertPro user [Y|N]
   my $pw           = "";                           # user password. blank disables password reminder email.

   for my $i (1 .. 10) {                            # sample code to assign a random password (in plaintext for password reminder email)
       $pw .= sprintf("%x", rand 16);
   }

### end of user settings

# Create a user agent object
   my $ua = LWP::UserAgent->new;

   $ua->from('rackping@example.com');
   $ua->timeout($timeout); # 411 - not reliable for https requests?
   $ua->max_redirect($max_redirects);

   my @headers = (
      'Accept'         => 'application/json',
      'Accept-Charset' => 'utf-8',
      'App-key'        => "$api_key",
      'Authorization'  => 'Basic ' . encode_base64("$user:$password", ''),
      'Content-type'   => 'application/json',
      'User-Agent'     => $useragent,
   );

   $ua->default_header(@headers);

# Create a request to add one contact

   my $form = [
      first       => $first,
      last        => $last,
      email       => $email,
      role        => $role,
      cellphone   => $cellphone,
      countrycode => $countrycode,
      countryiso  => $countryiso,
      password    => $pw,
      lang        => $lang,
      timezone    => $timezone,
      sendemail   => $sendemail,
      alertable   => $alertable,
   ];

   my $res = $ua->post( $url . "/contacts", Content => $form );

   print STDERR "info: add one contact\n";

# Check the outcome of the response
   if ($res->code() == 200) {
      print $res->content, "\n";
   }
   else {
      print $res->status_line, "\n";
      exit 1;
   }

   exit 0;

