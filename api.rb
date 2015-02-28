#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'webmachine'
require 'hiredis'
require 'redis'
require 'securerandom'

require_relative 'lib/resources'

redis = Redis.new
redis.set 'seed', SecureRandom.random_number(999_999_999) unless redis.get 'seed'

# Enable tracing on all resources.
# class Webmachine::Resource
#   def trace?
#     true
#   end
# end

API = Webmachine::Application.new do |app|
  app.routes do
    # add ['trace', :*], Webmachine::Trace::TraceResource
    add ['sites'], SitesResource
    add ['sites', :id], SiteResource
  end

  app.configure do |config|
    config.ip = '0.0.0.0'
    config.port = '9000'
    config.adapter = :Reel
  end
end

API.run
