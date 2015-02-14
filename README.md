# globalNetflix

This program allows for scripted DNS update on a OpenWRT-installed router
Note that it requires a rsa key set up on the router (.ssh/authorized_keys) to allow the script ssh access 

You can also use the script to change a local DNS address (OS X) if you want to view Netflix U.S. on your own PC
Currently only a single HTTP site is polled for DNS data

Usage
-----
Clone the git repo,
make sure the main program updateDNSregion.rb is runnable: 

```
chmod +x updateDNSregion.rb
```
```
./updateDNSregion.rb # sets Netflix DNS to U.S.
./updateDNSregion --reset # resets config
./updateDNSregion --local # makes change on local Mac
./updateDNSregion --help # shows more options
```

2do: 
-----
* Rsa key generation script build in on 1st run?
* better user interaction support (ask for basic settings, e.g. router url, rsa key location on 1st run)


See https://openwrt.org or  http://www.gargoyle-router.com (GUI-version)
for instructions on getting this excellent open source router software!
