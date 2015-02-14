# globalNetflix

This program allows for scripted DNS update on a OpenWRT-installed router
Note that it requires a rsa key set up on the router (.ssh/authorized_keys) to allow the script ssh access 

You can also use the script to change a local DNS address if you want to view Netflix U.S. on your own PC
Currently only a single HTTP site is polled for DNS data

2do: 
-----
* Rsa key generation script build in on 1st run?
* better user interaction support (ask for basic settings, e.g. router url, rsa key location on 1st run)


See https://openwrt.org or  http://www.gargoyle-router.com (GUI-version)
for instructions on getting this excellent open source router software!
