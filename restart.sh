#!/bin/bash

#echo "Programul a rulat!"
if [ -f /var/www/html/reboot.sh ]; then
  source /var/www/html/reboot.sh
fi
