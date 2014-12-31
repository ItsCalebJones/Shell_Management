Shell_Management
================

A daily shell script that gets the status of a list of servers.

The script executes in three parts.

1) hostname.txt - a file with a list of IP's or hostnames.
2) DialyUpdate.sh - script that is executed locally.
3) checkup.sh - script that is pushed to each server and executed via DailyUpdate.sh

I am sure there are better open source tools availabe, I simply wanted to write my own management script for experience. Feel free to borrow/contribute if you see a better way.
