#!/usr/bin/perl

# Program: rp_schedule_maint.pl
# Usage: ./rp_schedule_maint.pl id "start" "end"
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

   if (scalar @ARGV < 3) {
      print qq[usage: $0 id "start" "end"\n];
      exit 1;
   }

### start of user settings

   my $check  = shift // '';
   my $start  = shift // '';
   my $end    = shift // '';

   $start =~ s/ /%20/g;
   $end   =~ s/ /%20/g;

### end of user settings

# Create a user agent object
   my $ua = LWP::UserAgent->new;
   $ua->agent("RackPing/0.1");
   $ua->from('rackping@example.com');
   $ua->timeout($timeout); # 411 - not reliable for https requests?

# Add auth token to user agent
   $ua->default_header('Authorization' => 'Basic ' . encode_base64("$user:$password", ''));

# Create a request for one check. The format is MySQL, or ISO without the 'T' and no fractional seconds.

   my $req = HTTP::Request->new(PUT => $url . "/checks/$check?start_maintenance=$start&end_maintenance=$end");
   $req->header('App-key' => "$api_key");

# Pass request to the user agent and get a response back
   my $res = $ua->request($req);

   print STDERR "info: start maintenance on one check\n" if $DEBUG;

# Check the outcome of the response
   if ($res->is_success) {
      print $res->content, "\n";
   }
   else {
      print $res->status_line, "\n";
      exit 1;
   }

   exit 0;

