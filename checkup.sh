##Variable Initialization
#Variables for checking if my processes filepath and binary is on the server.
process="vpnserv"
processPath="/opt/airwatch/vpnd"
processConfig="/opt/airwatch/vpnd/server.conf"
hname=$(hostname --fqdn)
ipadd=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')

##Define Functions

#Function to check if process is installed.
function isInstalled()
{
if [ -d $processPath ]; then
Installed=true
    if [ -f $processConfig ]; then
        Installed=true
    else
        Installed=false
    fi
else
    Installed=false

fi
}

#Function to check if process is running.
function isRunning()
{
        if [ "$(pidof $process)" ] 
then
    checkV="Running"
else
    checkV="Stopped"
fi
}

#Function to check how long process has been running and return process ID.
function show_start_time()
{
        pid=`ps -ef | grep $process | grep -v grep | awk '{print $2}'`
        user_hz=$(getconf CLK_TCK) #mostly it's 100 on x86/x86_64
        jiffies=$(cat /proc/$pid/stat | cut -d" " -f22)
        #UPTIME=$(grep btime /proc/stat | cut -d" " -f2)  #this is the seconds when booting up
        sys_uptime=$(cat /proc/uptime | cut -d" " -f1)
        last_time=$(( ${sys_uptime%.*} - $jiffies/$user_hz ))
        last_time=$(echo "$last_time/60" | bc)
        echo "$process running on process $pid up for $last_time minutes."
}

#Find information from config file if process is running.
function ifRunning()
{
    if [ "$checkV" == "Running" ];
then
        
        locationGroup=$(awk '/API server address/{getline; print}' $processConfig)
        hostServer=$(awk '/Location group name/{getline; print}' $processConfig)
        debugLevel=$(awk '/## 5 - Trace/{getline; print}' $processConfig)
        show_start_time $pid
        echo ""
        echo "$locationGroup"
        echo ""
        echo "$hostServer"
        echo ""
        checkDebug
else
        echo "$process service is not running"
        echo ""
        echo "Starting $process service..."
        echo ""
        startService

fi
}

##Fucntion to check the debug level of my server.
function checkDebug()
{
    log_level=$(sed -n -e '/log_level/p' /opt/airwatch/vpnd/server.conf)
    log_level="${log_level:10}"
    if [ $log_level = "4" ]
    then
        echo ""
        echo "Logging currently set to Debug."
        echo ""
    else
        echo ""
        echo "Setting logging to Debug."
        echo ""
        setLogDebug
    fi

}

##Fucntion to set the debug level of my server.
function setLogDebug()
{
    sudo stop $process > /dev/null
    ##Context specific check for my environments
    sudo sed -i '/log_level/c\log_level 4' /opt/airwatch/vpnd/server.conf
    sudo start $process > /dev/null
    echo ""
    echo "Service restarted..."
    echo ""
}

function startService()
{
    setLogDebug
    sudo tail /var/log/messages | grep $process
}


###-Main Thread-###

##Prints name and IP of the Server
echo "#-------------------------------#"
echo "Connected"
echo "Server: $hname"
echo "IP Address:$ipadd"
echo "#-------------------------------#"
echo ""
isInstalled

if [ "$Installed" = true ]; then

#Calls isRunning funciton to see if vpnserver is running.
isRunning
ifRunning

else

    echo "$process Server does not appear to be installed..."
    echo ""

fi
echo ""
