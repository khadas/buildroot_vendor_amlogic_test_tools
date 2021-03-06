#!/bin/sh
#chkconfig:2345 80 90
#description:auto reboot

#sleep 8 sec waiting for system ready
sleep 8
REBOOT_COUNT_FILE=/test_plan/cpu/autoreboot/reboot_count_file
if [ ! -f ${REBOOT_COUNT_FILE} ]
then
	exit 17
fi
		
#read reboot count is 0 or not
current_reboot_count=$(cat ${REBOOT_COUNT_FILE} | awk -F  = '{print $2}')
if [ ${current_reboot_count} -gt 0 ]
then
	#substract reboot count
    let current_reboot_count-=1
	#rewrite reboot count
	echo "reboot_count=${current_reboot_count}" > ${REBOOT_COUNT_FILE}
	#continue reboot
	reboot -f
elif [  ${current_reboot_count} -eq 0 ]
then
	rm ${REBOOT_COUNT_FILE}
    mkdir -p /test_log/cpu
    echo "autoreboot=success"  > /test_log/cpu/autoreboot.lgo
fi

