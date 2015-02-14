#!/usr/bin/ruby
require 'net/http'
require 'trollop'
require './Updater.rb'

defaultRegion = "U.S."
opts = Trollop::options do
  opt :region, "Netflix region to change to (default #{defaultRegion}) NOT YET SUPPORTED", :type=> :string, :default => defaultRegion
  opt :local, "Change local DNS instead of on Router - Changes for ALL domains!"
  opt :reset, "Reset to default DNS"
end
p opts


begin
  updater = Updater.new
  newDns = opts.reset ? "" : updater.getNewDNS(opts.region)
  puts "Found new DNS for #{opts.region}: #{newDns}"
  
  updater.updateDNS(newDns, "remote")
  
  searchUrl = "https://netflixaroundtheworld.com"
  netflix = "http://www.netflix.com"  
  # also see http://www.moreflicks.com
  
  puts "opening #{netflix}"
  system("open -a safari #{netflix}")
rescue
  puts " - An error occurred - "
  puts $!,$@
end