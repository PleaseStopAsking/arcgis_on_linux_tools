#!/bin/bash

# Start of a script that would assist analysts in gathering important info from a linux system running ArcGIS for troubleshooting purposes.

#############
# VARIABLES #
#############

log_dir=/home/logs
awk_filter='{if(NR==1){print "PID, RUSER, STARTED, %CPU, %MEM, RSS, COMMAND";}else{print  $1 "," $2 "," $3 "," $4 "," $5 "," $6 "," $7;}}'
ps_filter='pid,ruser,start,%cpu,%mem,rss,command'
sort=''

#############
# FUNCTIONS #
#############

function create_log_dir
{
    if [ ! -d "$log_dir" ]
    then
        mkdir "$log_dir" 2>&1 | tee $LOG
    fi
}

function monitor_message
{
    clear
    echo '    ============================================'
    echo '     Monitoring will update every 5s.          '
    echo '     Press Ctrl-C to exit.                      '
    echo '    ============================================'
    echo
    read -p '     Press [Enter] to start Monitor mode.'
}

function sort_order
{
    clear
    echo '    ============================================'
    echo '     How do you want to sort the monitoring     '
    echo '     results?                                   '
    echo '    ============================================'
    echo
    echo '    1) RAM'
    echo '    2) CPU'
    read -e -p '    Answer: ' ansr
    echo
    if [[ ! $ansr =~ ^[1]$ ]]
    then
        sort='--sort=-%cpu'
    else
        sort='--sort=-rss'
    fi
    echo
}

function query_arcsoc
{
    ps -C arcsoc $sort -o $ps_filter
}

function query_java
{
    ps -C java $sort -o $ps_filter
}

function query_wine
{
    ps -C wine $sort -o $ps_filter
}

function query_all
{
    ps -C arcsoc,java,wine $sort -o $ps_filter
}

function monitor_menu
{
    while :
do
    clear
    cat<<EOF
    ========================================
    What process would you like to monitor?
    ----------------------------------------
    Please enter your choice:
    (1) arcsoc
    (2) java
    (3) wine
    (4) All three
    (R) Return to main menu
    ----------------------------------------
EOF
    read -n1 -s -p '    Selection: '
    echo
    case "$REPLY" in
    "1")  echo
	  sort_order
          monitor_message
	  watch -n 5 ps -C arcsoc $sort -o $ps_filter;;
    "2")  echo
	  sort_order
	  monitor_message
	  watch -n 5 ps -C java $sort -o $ps_filter;;
    "3")  echo
	  sort_order
          monitor_message
	  watch -n 5 ps -C wine $sort -o $ps_filter;;
    "4")  echo
	  sort_order
	  monitor_message
	  watch -n 5 ps -C arcsoc,java,wine $sort -o $ps_filter;;
    "R")  return                    ;;
    "r")  return                    ;;
     * )  echo "invalid option"     ;;
    esac
    sleep 1
done
}

<<COMMENT1
function record_menu
{

while :
do
    clear
    cat<<EOF
    ========================================
    What process would you like to record?
    ----------------------------------------
    Please enter your choice:
    (1) arcsoc
    (2) java
    (3) wine
    (4) All three
    (R) Return to main menu
    ----------------------------------------
EOF
    read -n1 -s -p '    Selection: '
    echo
    case "$REPLY" in
    "1")  echo
          query_arcsoc | awk -v filter='$awk_filter' 'filter' >> $log_dir/termi.log
          echo;;
    "2")  echo
	  query_java | awk -v filter='$awk_filter' 'filter' >> $log_dir/termi.log
          echo;;
    "3")  echo
	  query_wine | awk -v filter='$awk_filter' 'filter' >> $log_dir/termi.log
          echo;;
    "4")  echo
	  query_all | awk -v filter='$awk_filter' 'filter' >> $log_dir/termi.log
          echo;;
    "R")  return                    ;;
    "r")  return                    ;;
     * )  echo "invalid option"     ;;
    esac
    sleep 1
done
}
COMMENT1


function menu
{
    while :
do
    clear
    cat<<EOF
    ==============================
    Termi
    ------------------------------
    Please enter your choice:
    (1) Monitor
    (2) Record
    (Q) Quit
    ------------------------------
EOF
    read -n1 -s -p '    Selection: '
    echo
    case "$REPLY" in
    "1")  echo
          monitor_menu;;
    "2")  echo
	  #create_log_dir
	  #record_menu
          echo ' Feature is currently being developed'
   	  sleep 2;;
    "Q")  exit                      ;;
    "q")  exit                      ;; 
     * )  echo "invalid option"     ;;
    esac
    sleep 1
done
}

########
# MAIN #
########

menu
