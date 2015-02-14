#!/usr/bin/ruby
require 'net/http'
require 'trollop'
require './Updater.rb'

defaultRegion = "U.S."
opts = Trollop::options do
  opt :region, "Netflix region to change to (default #{defaultRegion}) NOT YET SUPPORTED", :type=> :string, :default => defaultRegion
  opt :local, "Change local DNS instead of on Router - Changes for ALL domains!"
  opt :reset, "Reset to default DNS"
  opt :dns_index, "Which found DNS to use (default is first)", :default => 0
end
p opts


begin
  updater = Updater.new
  newDns = ""
  if opts.reset 
    puts "Setting DNS to default (router)"
  else
    newDns = updater.getNewDNS(opts.region, opts.dns_index)
    puts "Found new DNS for #{opts.region}: #{newDns}"
  end
  host = opts.local ? "local" : "remote"
  updater.updateDNS(newDns, host)
  
  searchUrl = "https://netflixaroundtheworld.com"
  netflix = "http://www.netflix.com"  
  # also see http://www.moreflicks.com
  
  puts "opening #{netflix}"
  system("open -a safari #{netflix}")
rescue
  puts " - An error occurred - "
  puts $!,$@
end