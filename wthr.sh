#!/bin/bash

# run the script with cmd-expansion/brace-expansion arg

wttr_loop $(cat /home/pi/.weather/locations{1,2}.txt)
