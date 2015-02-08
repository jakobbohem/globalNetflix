#!/usr/bin/ruby
require 'net/http'

doReset = false
if ARGV[0] == "reset"
  doReset = true
end

uri = URI("http://www.netflixdnscodes.com")
res = Net::HTTP.get_response(uri)

file = File.open("dnscodes.html", "w")
file << res.body
file.close

regexp = /.*high success rate/
line = regexp.match(res.body)

puts line # just 1?? good for now
newDns = /\d{3}\.\d{3}\.\d{3}\.\d{3}/.match(line.string)
newDns = doReset ? "192.168.1.1" : newDns

begin
  system("sudo networksetup -setdnsservers Wi-Fi #{newDns}")
  puts "updated DNS to: #{newDns}"
  
  puts "opening https://netflixaroundtheworld.com"
  # also see http://www.moreflicks.com
  system("open -a safari https://netflixaroundtheworld.com")
rescue
  puts "An error occurred"
end