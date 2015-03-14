require 'net/http'

class Updater
  # defines
  @@LOCAL = "local"
  @@REMOTE = "remote"
  @@CHUNK_SIZE = 12 # for chunked router command operation
  # remote_host = "192.168.1.1"
  # rsa_key = "~/.ssh/router_rsa"

  # todo: add check for rsa key
  # add check for router -> fallback on local
  # add rsa key generation script (install)

  def initialize()
    @remote_host = "192.168.1.1"
    @rsa_key = "~/.ssh/router_rsa"
    @dns_source = "http://www.netflixdnscodes.com"
  end
  
  def serverCommand(command)
    return  "ssh -i #{@rsa_key} root@#{@remote_host} '#{command}'"
  end
  
  def getNewDNS(region, index)
    # todo: switch on region, also 'reset'
    uri = URI(@dns_source)
    res = Net::HTTP.get_response(uri)

    #save local copy (e.g. quick lookup)
    file = File.open("dnscodes.html", "w")
    file << res.body
    file.close

    regexp = /.*high success rate.*\n^.*/ #specific to dns_source
    lines = res.body.scan(regexp)
    puts "got #{lines.size} DNS hits from #{@dns_source}"
    if index >= lines.size 
      puts "WARN: desired index oob. Falling back on last"
      index = lines.size-1
    end
    # newDns = /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/.match(lines[0])
    dnss = lines[index].scan(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/)
    
    return dnss
  end
  
  def getRemoteMapping
    load_cmd = serverCommand("/sbin/uci get dhcp.@dnsmasq[0].server")
    list = `#{load_cmd}`.split(' ')
    return list
  end
  
  def updateDNS(dns_addr, host)
  case host
    
  when @@LOCAL
    newDns = dns_addr.empty? ? @remote_host : dns_addr.join(" ")
    updateDNScommand = "sudo networksetup -setdnsservers Wi-Fi #{newDns}"
    puts updateDNScommand
    system(updateDNScommand) 
    
  when @@REMOTE
    list = getRemoteMapping()    
    updated_list = list.reject {|x| x.include?("netflix")}    
    addback_list = updated_list.map {|entry| "/sbin/uci add_list dhcp.@dnsmasq[0].server=#{entry};"}

    #todo: speed up with 1 ssh call??
    clear_cmd = serverCommand("/sbin/uci revert dhcp")
    delete_cmd = serverCommand("/sbin/uci delete dhcp.@dnsmasq[0].server")
    `#{clear_cmd}`
    `#{delete_cmd}`
     
    addback_list.each_slice(@@CHUNK_SIZE) do |sublist|
      command = sublist.join
      #DEBUG puts command
      write_cmd = serverCommand(sublist.join) #"ssh -i #{@rsa_key} root@#{@remote_host} '#{command}'"
      `#{write_cmd}`
    end

    # add new dns if did not request --reset
    if not dns_addr.empty?
      add_new_dns = ""
      if dns_addr.is_a?(Array)
        dns_addr.each do |dns|
          add_new_dns += "/sbin/uci add_list dhcp.@dnsmasq[0].server=/netflix.com/#{dns};"
        end        
      else
        add_new_dns = "/sbin/uci add_list dhcp.@dnsmasq[0].server=/netflix.com/#{dns_addr}"
      end
      system(serverCommand(add_new_dns))
    end
    
    push_settings = "ssh -i #{@rsa_key} root@#{@remote_host} '/sbin/uci commit dhcp'"
    restart_service =  "ssh -i #{@rsa_key} root@#{@remote_host} '/etc/init.d/dnsmasq reload'"
    `#{push_settings}`
    `#{restart_service}`
    
  end
  
  puts "done."
  end #case
end