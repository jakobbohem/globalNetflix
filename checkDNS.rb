#!/usr/bin/ruby
require './Updater.rb'

updater = Updater.new
netflix_dnss = updater.getRemoteMapping().reject {|it| !it.include?("netflix")}

puts "Current router 'netflix' DNS settings: "
netflix_dnss.each { |item| puts item }
if netflix_dnss.empty?
  puts "'netflix' uses deafault router DNS settings!"
end
