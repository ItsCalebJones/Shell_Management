##Variable Initialization
today=$(date +%m-%d-%Y)
xemails="youremail@email.com"

##Point this logfile to somewhere on your machine that makes sense.
logfile=~/Desktop/DailyReport_$today.txt

##Start logging to that file
echo "Beginning remote connections..." >> $logfile
echo "" >>logfile

##Point to a file with a list of Servers in the for loop.
#
# Example file below, just one line after the other list of server addresses or IPs.
#10.0.0.1
#10.0.0.2
#calebjones.me
for servers in $(cat ~/Documents/Development/Scripts/hostnames.txt); do
	echo "Starting connection to $servers" >> $logfile
    (rsync -av ~/Documents/Development/Scripts/checkup.sh cjones@$servers:~/checkup.sh > /dev/null
    echo""
    ssh -t $servers "sudo ./checkup.sh") >> $logfile
    echo ""
done

##Formatting bottom of logfile to make it 'pretty' for an email.
echo "John Doe" >> $logfile
echo "Signature Title" >> $logfile
echo "O | 404.404.4040" >> $logfile
echo "C | 505.505.5050" >> $logfile
echo "cjones@calebjones.me" >> $logfile
echo "This communication is confidential and is intended to be privileged pursuant to applicable law. If you are not a designated recipient of this message, please do not read, copy, use or disclose this message or its attachments. Notify the sender by replying to this message and delete or destroy all copies of this message and attachments in all media. Thank you." >> $logfile

##Uses local machine mail account to send email using input from logfile then opens log file for local viewing.
mail -s "TESTING| Server Status - $today" $xemails < $logfile
open $logfile
