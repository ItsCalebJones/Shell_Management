##Define Functions

#Function to check if /etc/opt/airwatch/vpnd/vpnserv exist
function isInstalled()
{
if [ -d "/opt/airwatch/vpnd/" ]; then
Installed=true
    if [ -f "/opt/airwatch/vpnd/vpnserv" ]; then
        Installed=true
    else
        Installed=false
    fi
else
    Installed=false

fi
}

#Function to check if vpnserv is running
function isRunning()
{
        if [ "$(pidof vpnserv)" ] 
then
    checkV="Running"
else
    checkV="Stopped"
fi
}

#Function to check how long vpnserv has been running and return process ID.
function show_start_time()
{
        pid=`ps -ef | grep vpnd | grep -v grep | awk '{print $2}'`
        user_hz=$(getconf CLK_TCK) #mostly it's 100 on x86/x86_64
        jiffies=$(cat /proc/$pid/stat | cut -d" " -f22)
        #UPTIME=$(grep btime /proc/stat | cut -d" " -f2)  #this is the seconds when booting up
        sys_uptime=$(cat /proc/uptime | cut -d" " -f1)
        last_time=$(( ${sys_uptime%.*} - $jiffies/$user_hz ))
        last_time=$(echo "$last_time/60" | bc)
        echo "VPND running on process $pid up for $last_time minutes."
}

#Find Location Group and AirWatch console hostname if server is running.
function ifRunning()
{
    if [ "$checkV" == "Running" ];
then
        
        locationGroup=$(awk '/API server address/{getline; print}' /opt/airwatch/vpnd/server.conf)
        hostServer=$(awk '/Location group name/{getline; print}' /opt/airwatch/vpnd/server.conf)
        debugLevel=$(awk '/## 5 - Trace/{getline; print}' /opt/airwatch/vpnd/server.conf)
        show_start_time $pid
        echo ""
        echo "$locationGroup"
        echo ""
        echo "$hostServer"
        echo ""
        checkDebug
else
        echo "VPN service is not running"
        echo ""
        echo "Starting VPND service..."
        echo ""
        startService

fi
}

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

function setLogDebug()
{
    sudo stop vpnd > /dev/null
    sudo sed -i '/log_level/c\log_level 4' /opt/airwatch/vpnd/server.conf
    sudo start vpnd > /dev/null
    echo ""
    echo "Service restarted..."
    echo ""
}

function startService()
{
    setLogDebug
    sudo tail /var/log/messages | grep vpnd
}


##-Main Thread-#
#--------------#
#--------------#
#--------------#
##            ##



hname=$(hostname --fqdn)
ipadd=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')

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

    echo "VPN Server does not appear to be installed..."
    echo ""

fi
echo ""
