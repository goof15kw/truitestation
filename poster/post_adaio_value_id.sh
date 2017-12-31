#!/bin/bash
set -e 
DF=/tmp/data.file
cat > $DF << EOF
{ 
  "value": "$1", 
  "lat": "0",
  "lon": "0",
  "ele": "450"
}
EOF
shift
ID=$1
ID=${ID:-630602}
curl -k  -H "Content-Type: application/json" -H "X-AIO-Key: $(cat /home/pi/io.adafruit.key)" -X POST https://io.adafruit.com/api/feeds/$ID/data -d @$DF
 


