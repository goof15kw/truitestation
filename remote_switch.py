#!/usr/bin/python3
# Example of using the MQTT client class to subscribe to a feed and print out
# any changes made to the feed.  Edit the variables below to configure the key,
# username, and feed to subscribe to for changes.

# Import standard python modules.
import sys

# for, well, GPIOs
from gpiozero import LED

# Import Adafruit IO MQTT client.
from Adafruit_IO import MQTTClient
from Adafruit_IO import Client

import os
# Set to your Adafruit IO key.
# Remember, your key is a secret,
# so make sure not to publish it when you publish this code!
ADAFRUIT_IO_KEY = os.getenv('ADAFRUIT_IO_KEY')

# Set to your Adafruit IO username.
# (go to https://accounts.adafruit.com to find your username)
ADAFRUIT_IO_USERNAME = 'Goofencours'

# Set to the ID of the feed to subscribe to for updates.
FEED_ID = 'chauffe-01'


# Define callback functions which will be called when certain events happen.
def connected(client):
    # Connected function will be called when the client is connected to Adafruit IO.
    # This is a good place to subscribe to feed changes.  The client parameter
    # passed to this function is the Adafruit IO MQTT client so you can make
    # calls against it easily.
    print('Connected to Adafruit IO!  Listening for {0} changes...'.format(FEED_ID))
    # Subscribe to changes on a feed named DemoFeed.
    client.subscribe(FEED_ID)

def subscribe(client, userdata, mid, granted_qos):
    # This method is called when the client subscribes to a new feed.
    print('Subscribed to {0} with QoS {1}'.format(FEED_ID, granted_qos[0]))

def disconnected(client):
    # Disconnected function will be called when the client disconnects.
    print('Disconnected from Adafruit IO!')
    sys.exit(1)

def message(client, feed_id, payload):
    # Message function will be called when a subscribed feed has a new value.
    # The feed_id parameter identifies the feed, and the payload parameter has
    # the new value.
    print('Feed {0} received new value: {1}'.format(feed_id, payload))
    if (payload == "ON" ):
      led.on()
    else:
      led.off()


# Init led
# 14 is  110v outlet or socket-switch-pump-style
#led = LED(14)
# 15 is contactor
led = LED(15)
#led.off()
while True:
  try:
    # Create an instance of the REST client.
    aio = Client(ADAFRUIT_IO_USERNAME, ADAFRUIT_IO_KEY)

    chauffe01 = aio.feeds("chauffe-01")
    data = aio.receive(chauffe01.key)
    print('Initial fetch got {0}'.format(data.value))
    # This should forge a call to message... 
    if (data.value == "ON" ):
        led.on()
    else:
        led.off()
    aio = None

    # Create an MQTT client instance.
    client = MQTTClient(ADAFRUIT_IO_USERNAME, ADAFRUIT_IO_KEY,secure=True)

    # Setup the callback functions defined above.
    client.on_connect    = connected
    client.on_disconnect = disconnected
    client.on_message    = message
    client.on_subscribe  = subscribe

    # Connect to the Adafruit IO server.
    client.connect()

    # Start a message loop that blocks forever waiting for MQTT messages to be
    # received.  Note there are other options for running the event loop like doing
    # so in a background thread--see the mqtt_client.py example to learn more.
    client.loop_blocking()
  except Exception as e:
      print("Something went wrong, reconnecting:")
      print(e)
