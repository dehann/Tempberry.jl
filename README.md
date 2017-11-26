# Tempberry
Monitor, log, and host temperature probe data for science

# Introduction

This is a [Julia](http://www.julialang.org) ([JuliaPro](http://www.juliacomputing.com)) package for monitoring temperature data on a Raspberry Pi. The initial use case requires monitoring of incubators for cultures of marine bacteria. The idea is send text messages in the event temperature thresholds are exceeded, and maintain a log of historic temperature data. In addition the package can be used to host a local website that acts as a dashboard for quickly looking at the current system status.

## Background

The following blogs or tutorials were used to set up the associated hardware (although we used slightly different interface boards):
- [Adafruit Blog](http://learn.adafruit.com/adafruits-raspberry-pi-lesson-11-ds18b20-temperature-sensing/parts)
- [Multiple thermometers](http://www.reuk.co.uk/wordpress/raspberry-pi/connect-multiple-temperature-sensors-with-raspberry-pi/)
- [YouTube Tutorial](http://www.youtube.com/watch?v=aEnS0-Jy2vE)

## Bill of Materials

From Amazon:
- Among the many suppliers (which will work fine) this one is a good starting point [Rasberry Pi 3 ($35+)](http://www.amazon.com/CanaKit-Raspberry-Complete-Starter-Kit/dp/B01C6Q2GSY/ref=sr_1_1_sspa?ie=UTF8&qid=1511712539&sr=8-1-spons&keywords=raspberry+pi+3&psc=1), and remember that keyboard, mouse, and HDMI capable computer monitor will also be required. Some Pi kits (around $80) come with an additional small keyboard and mouse combo.
- [Skrew terminal breakout block](http://www.amazon.com/dp/B01M27459S/ref=sxbs_sxwds-stvp_1?pf_rd_m=ATVPDKIKX0DER&pf_rd_p=3341940462&pd_rd_wg=o9P8Y&pf_rd_r=FZ2DCVEDSQ6NJ0X32N33&pf_rd_s=desktop-sx-bottom-slot&pf_rd_t=301&pd_rd_i=B01M27459S&pd_rd_w=NOabk&pf_rd_i=raspberry+pi+3+gpio+connector&pd_rd_r=bc208bc5-0b16-42f5-b047-39db7fbad512&ie=UTF8&qid=1511712653&sr=1) to connect the thermometers to the Pi's General Purpose Input and Output (GPIO).
- [DS18B20 Waterproof digital thermometer 5 pack](http://www.amazon.com/Ds18b20-18b20-Thermometer-Temperature-Sensor/dp/B00OZGWWQA/ref=sr_1_4?s=industrial&ie=UTF8&qid=1511713027&sr=1-4&keywords=18B20+thermometer).

The keyboard, mouse, and monitor are only required for setup or debugging the Pi. The idea of this package is allow access to the data through web page hosted by the Pi. You can also access the Pi and data through remote terminals such as `ssh`, using your laptop to change and modify code on the Pi. Chances are you will be running Linux (Raspbian / Ubuntu) on the Pi itself.

## Warnings

- The large (optional) **heatsink** on the Pi's CPU is **too big** when trying to attach the skrew terminal block on top of the board. You can skip installation of the big heatsink when working in cooler environments with lower CPU load, or cut the bigger heatsink smaller before installing it. Alternatively, please file an issue with this repo if you find a smaller heatsink for purchase which can be reported here.
- **Change the username, password, and computer name** of the Raspberry Pi (after following the provided install procedures in preinstalled on the MicroSD card). If the Pi is exposed to the Internet, the standard computer name, username and no password (as default) is vulnerable to hackers. Hacker-bots **will** install malware or spamware on Pi, or use it as a weakpoint (trojan) behind your local firewall to access your network. Simply changing the username, password, and computer name make the Pi as resilient as any other computer on your network. Remember, the smart hackers won't let you discover they are doing something dodgy, so change the values now.

# Installation

To install Julia on this Raspberry Pi, open a terminal and tipe:
```bash
sudo apt-get update
sudo apt-get install julia
```
