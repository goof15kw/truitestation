from gpiozero import LED
from time import sleep
from random import uniform

led = LED(15)

def getsleep():
	s=uniform(1, 4)
#	print(s)
	return s

while True:
    led.on()
    sleep(getsleep())
    led.off()
    sleep(getsleep())

