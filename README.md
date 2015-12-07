Svirneblin Network Monitoring and Local Vulnerability Evaluation Toolkit
========================================================================

This is a tool for enumerating the hosts on a local network and for evaluating
the security of those hosts in a quick, automatic way. It just generates tiers
of menus which enumerate local hosts and the services running on those hosts.
Optionally, if it finds scripts which exploit potential vulnerabilities in those
services in a directory(Either /usr/bin/exploits or $HOME/.bin/exploits) it will
generate a menu for launching those scripts in a terminal under the enumerated
services in the menu. It's not compatible with any existing vulnerability
framework, but it shouldn't be particularly difficult to wrap your applications
up in the exploits/ folder. An example script exploiting the shellshock
vulnerability will be included as an example shortly.  

**Don't use this version unless you are interested in testing the features of**
**the script.** It's not capable of updating the menu asynchronously yet which 
means that it will take a long time for your window manager to start up, and
you'll have to restart the window manager to refresh the menu.  

        [X] Menu Generation
        [X] Service Scanning
        [X] Potential Exploit Scanning
        [x] Example Exploit(Untested)
        [_] Asynchronous Updates
        [_] Exploit Library
        [_] Custom Port Ranges
        [_] 

How it works:
-------------
It uses 3 wrapper scripts to turn data from the shell into lists that can be
used to create hierarchical awesome menus and launchers. The code's not
particularly concise yet, but it's pretty well labeled except in that one area.

###Refreshing the Menu
I wouldn't recommend setting a timer to automatically refresh the menu at an
interval, as this version is not yet capable of doing so asynchronously and it
will stall while the window manager while it's scanning your network. 

###Menu Level 1: Computers Nearby
This list is formulated by determining which networks you are connected to and
guessing which IP ranges are being assigned by those networks, then scanning
those ranges with nmap and organizing that data into the first level menu. This
should be enough to discover all hosts on most SOHO networks and display them
in the menu.

####Example Gateway in Menu Level 1 with Host Name:

        wrt54g (192.168.1.1) Host is up (0.0018s)

####Example Host with Hostname

        MemA 192.168.1.4 Host is up (0.0010s)

####Example Host with IP address

        for 192.168.1.105 Host is up (0.0012s)

I might add the capability to scan custom IP ranges soon too but for now it only
scans the local network automatically.

###Menu Level 2: Service Scanning

###Menu Level 3a: Potential Attacks

###Menu Level 3b: Service Fingerprinting
Not implemented yet, but

