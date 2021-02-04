#!/usr/bin/ruby

# Program: rp_add_contact.rb
# Usage: ./rp_add_contact.rb
# Purpose: ruby language sample client program for RackPing Monitoring API 2.0
# Copyright: RackPing USA 2020
# Env: Ruby 2
# Notes: sudo gem install httparty
#  source ../set.sh

require 'rubygems'
require 'httparty'

user=ENV['RP_USER']
pass=ENV['RP_PASSWORD']
$api_key=ENV['RP_API_KEY']

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
  headers 'Content-Type' => 'application/json'
  headers 'App-key' => $api_key

  if ENV['RP_DEBUG'] != "0"
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
# Create a request to add one contact

   $pw = rand(36**8).to_s(36)

   data = {
      'first'       => 'John',
      'last'        => 'Doe',
      'email'       => 'john.doe+' + $api_key + '@example.com',
      'role'        => 'O',
      'cellphone'   => '408 555 1212',
      'countrycode' => '1',
      'countryiso'  => 'US',
      'alertable'   => 'N',
      'sendemail'   => 0,
      'password'    => $pw,
   }

   success = 0
   $stderr.puts "Add one contact:"
   url='/contacts'
   response = RackPing.new(user, pass).post(url, data)
   if response.code == 200
      puts response.body, "\n"
      success = 1
   else
      puts response.inspect, "\n"
   end

rescue => e
  puts "Rescued: #{e.inspect}", "\n"
end

exit 0

