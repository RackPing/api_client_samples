#!/usr/bin/perl

# Program: rp_update_contact.pl
# Usage: ./rp_update_contact.pl id
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

   my $contactid    = shift // '';

   my $first        = 'JohnJohn';
   my $last         = 'Doe';
   my $email        = 'john.doe+' . $api_key . '@example.com';
   my $role         = 'O';
   my $cellphone    = '408 555 1212';
   my $countrycode  = '1';
   my $countryiso   = 'US';

### end of user settings

   if ($contactid eq '') {
      print "usage: $0 id\n";
      exit 1;
   }

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

   my $form = {
      first       => $first,
      last        => $last,
      email       => $email,
      role        => $role,
      cellphone   => $cellphone,
      countrycode => $countrycode,
      countryiso  => $countryiso,
   };

# Create a request to update one contact
   my $res = $ua->put( $url . "/contacts/$contactid", Content => $form );

   print STDERR "info: update one contact\n";

# Check the outcome of the response
   if ($res->code() == 200) {
      print $res->content, "\n";
   }
   else {
      print $res->status_line, "\n";
      exit 1;
   }

   exit 0;

