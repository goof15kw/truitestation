if ! ping -c1 192.168.43.1; 
then
 
		if ! ps axf | grep -v grep | grep  wpa_supplicant; 
			then 
				sudo wpa_supplicant -B -iwlan0 -f/var/log/wpa_supplicant.log -c/etc/wpa_supplicant/wpa_supplicant.conf; 
		fi; 
#	sleep 20
fi
