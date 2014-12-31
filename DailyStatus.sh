##WORKING REMOTELY EXECUTING SCRIPT
today=$(date +%m-%d-%Y)
xemails="cjones@air-watch.com"

# rsync -av ~/Documents/Development/Scripts/checkup.sh cjones@qavpn.airwatchqa.com:~/checkup.sh
# echo ""
# echo ""
# ssh -t cjones@qavpn.airwatchqa.com 'sudo ./checkup.sh' >> ~/Desktop/DailyReport_$today.txt

#List of Servers
host1="qavpn.airwatchqa.com"
host2="10.43.70.183"
logfile=~/Desktop/DailyReport_$today.txt

echo ""
echo "Beginning remote connections..." >> $logfile
echo "" >>logfile

for servers in $(cat hostnames.txt); do
	echo "Starting connection to $servers" >> $logfile
    (rsync -av ~/Documents/Development/Scripts/checkup.sh cjones@$servers:~/checkup.sh > /dev/null
    echo""
    ssh -t $servers "sudo ./checkup.sh") >> $logfile
    echo ""
done

echo "Caleb Jones" >> $logfile
echo "App Tunnel – Quality Assurance" >> $logfile
echo "O | 404.902.4869" >> $logfile
echo "C | 770.634.6335" >> $logfile
echo "cjones@air-watch.com" >> $logfile
echo "This communication is confidential and is intended to be privileged pursuant to applicable law. If you are not a designated recipient of this message, please do not read, copy, use or disclose this message or its attachments. Notify the sender by replying to this message and delete or destroy all copies of this message and attachments in all media. Thank you." >> $logfile


mail -s "TESTING| Server Status - $today" $xemails < $logfile
open $logfile
