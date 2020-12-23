export ADAFRUIT_IO_KEY=$(cat /home/pi/io.adafruit.key)
fswebcam - 2>/dev/null | base64 | tr -d "\n"  | curl -F value=@- -H "X-AIO-Key: $ADAFRUIT_IO_KEY"  https://io.adafruit.com/api/v2/Goofencours/feeds/image/data
