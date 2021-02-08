#!/bin/bash
#
#users=$(cat /etc/passwd | grep "bash\|sh\zsh\|tsh\|ksh" | awk -F':' '{print $1}'| lastlog -u)
#echo "$users"
begin_time=$(date)
words="panic crash halt reboot dump restart shutdown 100%"

fnFormatting(){
echo "*************** ${FUNCNAME[0]} is running ***************" 
echo "************  Searching for $word.  ****************"
echo ""
}

fnShowUsers(){
echo "*************** ${FUNCNAME[0]} is running ***************" 
for user in $(cat /etc/passwd | grep "bash\|sh\|zsh\|tsh\|ksh" | awk -F':' '{print $1}')  ; do 
lastlog -u $user; 
echo "<<<<<<<Last commands run by $user >>>>>>>"
if [[ "$user" -ne root ]] 
 then tail -7 /home/$user/.*history
else 
  tail -15 /root/.*history
fi
echo " "
done
#echo "Show Users"
}

fnFindWordsInLogs(){
echo "*************** ${FUNCNAME[0]} is running ***************" 
for word in $words; do 
#BASE Understanding of Linux.
#Globally search for regular expressions and print matching lines.  --- #grep   
fnFormatting
logs="messages boot.log dmesg cron waagent.log"
for log in $logs; do cat /var/log/$log | grep -ni $word
done
done
}


fnDiskInfo(){
echo "*************** ${FUNCNAME[0]} is running ***************" 
echo "<<<<<<<<<<<<<<<< Disk Info >>>>>>>>>>>>>>>>>>>"
#for fstab_entry in $(cat /etc/fstab | awk -F' ' '{print $2}'); do 
	df -h  
#du -h $fstab_entry
#done
}

case $1 in 
	all)
	#RunAllFunctions
	  fnShowUsers;
	  fnFindWordsInLogs;
	  fnDiskInfo;
	;;
	users)
	  fnShowUsers;
	;;
	logs)
	  fnFindWordsInLogs;
	;;
	disk)
	  fnDiskInfo;
	;;
  *)
echo $"Usage: $0 {all|users|logs|disk}"
exit 1
esac

