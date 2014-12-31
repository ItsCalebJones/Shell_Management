Shell_Management
================

###A daily shell script that gets the status of a list of servers.

Files:
---
1. hostname.txt - a file with a list of IP's or hostnames.
2. DialyUpdate.sh - script that is executed locally.
3. checkup.sh - script that is pushed to each server and executed via DailyUpdate.sh

I am sure there are better open source tools availabe, I simply wanted to write my own management script for experience. Feel free to borrow/contribute if you see a better way.

Installation Notes:
---
1. Copy all files to one directory.
2. Configure SSH with Public Key authentication. (Link: http://www.thegeekstuff.com/2008/11/3-steps-to-perform-ssh-login-without-password-using-ssh-keygen-ssh-copy-id/)
3. Create a hostname.txt file.
4. Execute DailyUpdate.sh
