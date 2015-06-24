LOGFILE=/var/log/live-swapfile

get_device_info ()
{
	DEVICE="${1}"
	PROPERTIES="$(udevadm info --name=${DEVICE} --query=property)"
	ID_MODEL=""
	ID_FS_LABEL=""
	ID_FS_TYPE=""
	eval $(echo "${PROPERTIES}" | grep ID_MODEL=)
	eval $(echo "${PROPERTIES}" | grep ID_FS_LABEL=)
	eval $(echo "${PROPERTIES}" | grep ID_FS_TYPE=)
	eval $(df | grep "^${DEVICE} "  | awk '{ print "SIZE="$2; print "FREE="$4 }')
	if [ -n "${SIZE}" ]
	then
		SIZE="$((${SIZE} / 1024))"
	fi
	if [ -n "${FREE}" ]
	then
		FREE="$((${FREE} / 1024))"
	fi
}

get_mount_point ()
{
	DEVICE=${1}
	MOUNTPOINT=$(grep "^${DEVICE} " /proc/mounts | awk '{ print $2 }')
	if [ -n "${MOUNTPOINT}" ]
	then
		echo " ${DEVICE} is mounted on ${MOUNTPOINT}" >> ${LOGFILE}
		UMOUNT=""
	else
		echo " ${DEVICE} is not yet mounted" >> ${LOGFILE}
		get_device_info ${DEVICE}
		if [ "${ID_FS_TYPE}" = "vfat" ]
		then
			MOUNT_OPTIONS="umask=0"
		else
			MOUNT_OPTIONS=""
		fi
		if udisks --mount ${DEVICE} --mount-options "${MOUNT_OPTIONS}" >> ${LOGFILE} 2>&1
		then
			MOUNTPOINT=$(grep "^${DEVICE} " /proc/mounts | awk '{ print $2 }')
			UMOUNT="true"
			echo " mounted ${DEVICE} on ${MOUNTPOINT}" >> ${LOGFILE}
		else
			echo " mounting ${DEVICE} failed" >> ${LOGFILE}
		fi
	fi
}

get_memory_info ()
{
	MEM_TOTAL_KB="$(awk '/^MemTotal: / { print $2 }' /proc/meminfo)"
	MEM_TOTAL_MB="$(expr ${MEM_TOTAL_KB} / 1024)"
	SWP_TOTAL_KB="$(awk '/^SwapTotal: / { print $2 }' /proc/meminfo)"
	SWP_TOTAL_MB="$(expr ${SWP_TOTAL_KB} / 1024)"
}
