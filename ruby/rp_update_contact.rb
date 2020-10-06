#!/usr/bin/ruby

# Program: rp_update_contact.rb
# Usage: ./rp_update_contact.rb
# Purpose: ruby language sample client program for RackPing Monitoring API 2.0
# Copyright: RackPing USA 2020
# Env: Ruby 2
# Notes: sudo gem install httparty
#  source ../set.sh

#require 'rubygems'
require 'httparty'

user=ENV['RP_USER']
pass=ENV['RP_PASSWORD']

class RackPing
  include HTTParty
# see http://www.rubydoc.info/github/jnunemaker/httparty/HTTParty/ClassMethods
  format :json
  base_uri ENV['RP_SCHEME']+ENV['RP_DOMAIN']+ENV['RP_BASE_URL']
  default_timeout ENV['RP_TIMEOUT'].to_f
  headers 'Content-Type' => 'application/json'
  headers 'App-key' => user=ENV['RP_API_KEY']
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
   id = ARGV[0]

   data = {
      'contactid'   => id,
      'first'       => 'JohnJohn',
      'last'        => 'Doe',
      'email'       => 'john.doe@gmail.com',
      'role'        => 'O',
      'cellphone'   => '408 555 1212',
      'countrycode' => 1,
      'countryiso'  => 'US'
   }

   success = 0
   puts "Update one contact:"
   url='/contacts/'+id
   response = RackPing.new(user, pass).put(url, data)
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

