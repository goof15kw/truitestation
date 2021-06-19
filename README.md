# V3.1 io.adafruit.com remoteswitch
* expose to io.adafruit.com using a few relays ( 120V and 240V via contactor)
* Used to remotely turn on heat
* systemd service files
** (Pasting lines from history, might not be 100% exact)
** sudo cp remoteswitchservice.sh /etc/init.d/
** sudo chmod +x /etc/init.d/remoteswitchservice.sh 
** sudo update-rc.d remoteswitchservice.sh defaults
** sudo /etc/init.d/remoteswitchservice.sh start
** journalctl  -u remoteswitchservice.service  -f


# V3 is live

* We now have internet at the truite!
* push out to io.adafruit.com every 5m
* pulls from the exporter setup in V2 (almost a year of data!)

# V2 is now live. 
Based on Prometheus, grafana and https://github.com/goof15kw/dht-exporter (thanks original authors)

Prometheus.yaml in the root if this repo along with rc.local and a dashboard.json. 

This repo is mainly my backup if the SD goes bad.

## BELOW IS DEPRECATED

# truitestation
Banale station meteo avec integration adafruit.io


To try: https://forums.adafruit.com/viewtopic.php?f=56&t=115521&p=577018&hilit=offline#p577018 

hunch: maybe we should use the v2 urls ? 
