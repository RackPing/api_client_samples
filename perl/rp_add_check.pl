#!/usr/bin/perl

# Program: rp_add_check.pl
# Usage: ./rp_add_check.pl
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

   my $api_key  = $ENV{'RP_API_KEY'}  // '';
   my $user     = $ENV{'RP_USER'}     // '';
   my $password = $ENV{'RP_PASSWORD'} // '';
   my $timeout  = $ENV{'RP_TIMEOUT'}  || TIMEOUT_SEC;
   my $DEBUG    = $ENV{'RP_DEBUG'}    || 0;

   if ($api_key eq '') {
      print "error: do source ../set.sh to set the envariables.\n";
      exit 1;
   }

### start of user settings

   $timeout = TIMEOUT_SEC;

   my $name       = 'Test';
   my $host       = 'https://rackping.com/';
   my $port       = 443;
   my $resolution = 5;

### end of user settings

# Create a user agent object
   my $ua = LWP::UserAgent->new;
   $ua->agent("RackPing/0.1");
   $ua->from('rackping@example.com');
   $ua->timeout($timeout); # 411 - not reliable for https requests?

# Add auth token to user agent
   $ua->default_header('Authorization' => 'Basic ' . encode_base64("$user:$password", ''));

# Create a request for one check

   my $form = [
      name       => $name,
      host       => $host,
      port       => $port,
      resolution => $resolution,
   ];

# Pass request to the user agent and get a response back

   my $res = $ua->post( $url . "/checks", 'App-key' => $api_key, Content => $form );

   print STDERR "info: add one check\n" if $DEBUG;

# Check the outcome of the response
   if ($res->is_success) {
      print $res->content, "\n";
   }
   else {
      print $res->status_line, "\n";
      exit 1;
   }

   exit 0;

