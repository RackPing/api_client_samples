#!/usr/bin/ruby

# Program: rp_schedule_maint.rb
# Usage: ./rp_schedule_maint.rb checkid 'start' 'end'
# Purpose: ruby language sample client program for RackPing Monitoring API 2.0
# Copyright: RackPing USA 2020
# Env: Ruby 2
# Notes: sudo gem install httparty
#  source ../set.sh

#require 'rubygems'
require 'httparty'

user=ENV['RP_USER']
pass=ENV['RP_PASSWORD']
$api_key=ENV['RP_API_KEY']
$debug=ENV['RP_DEBUG']

class RackPing
  include HTTParty
# see http://www.rubydoc.info/github/jnunemaker/httparty/HTTParty/ClassMethods
  format :json
  base_uri ENV['RP_SCHEME']+ENV['RP_DOMAIN']+ENV['RP_BASE_URL']
  default_timeout ENV['RP_TIMEOUT'].to_f

  if ENV['RP_REDIRECTS'].to_i > 0
     follow_redirects true
  else
     no_follow true
  end

  headers 'Accept' => 'application/json'
  headers 'Accept-Charset' => 'utf-8'
  headers 'App-key' => $api_key

  if $debug != "0"
     puts "info: enabling debug mode"
     debug_output
  end

  def initialize(user, pass)
    self.class.basic_auth user, pass
  end

  def get(url)
    self.class.get(url)
  end

  def post(url, text)
    self.class.post(url, :body => text.to_json)
  end

  def put(url, text)
    self.class.put(url, :body => text.to_json)
  end

  def delete(url)
    self.class.delete(url)
  end
end

begin
   id    = ARGV[0]
   start = ARGV[1]
   endd  = ARGV[2]

   start.gsub(/ /, "%20");
   endd.gsub(/ /, "%20");

   abort "usage: #{$PROGRAM_NAME} id 'start' 'end'" unless ARGV.length == 3

   data = nil

   success = 0
   puts "Enable maintenance window for one check:"
   url='/checks/' + id + '?start_maintenance=' + start + '&end_maintenance='+ endd
   response = RackPing.new(user, pass).put(url, data)
   if response.code == 200
      puts response.body, "\n"
      success = 1
   else
      if $debug != "0"
         puts response.inspect, "\n"
      end
      puts "HTTP response code: #{response.code}\n"
      exit 1
   end

rescue => e
  puts "Rescued: #{e.inspect}", "\n"
end

exit 0

