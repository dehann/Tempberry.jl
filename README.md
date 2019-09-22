# Tempberry
Monitor, log, and host temperature probe data for science

# Introduction

This is a [Julia](http://www.julialang.org) ([JuliaPro](http://www.juliacomputing.com)) package for monitoring temperature data on a Raspberry Pi. The initial use case requires monitoring of incubators for cultures of marine bacteria. The idea is send text messages in the event temperature thresholds are exceeded, and maintain a log of historic temperature data. In addition the package can be used to host a local website that acts as a dashboard for quickly looking at the current system status.

## Background

The following blogs or tutorials were used to set up the associated hardware (although we used slightly different interface boards):
- [Adafruit Blog](https://learn.adafruit.com/adafruits-raspberry-pi-lesson-11-ds18b20-temperature-sensing)
- [Multiple thermometers](http://www.reuk.co.uk/wordpress/raspberry-pi/connect-multiple-temperature-sensors-with-raspberry-pi/)
- [YouTube Tutorial](http://www.youtube.com/watch?v=aEnS0-Jy2vE)
- [OPTIONAL] [PWM GPIO driving](https://electronicshobbyists.com/raspberry-pi-pwm-tutorial-control-brightness-of-led-and-servo-motor/) for peltier control (WIP). 

## Bill of Materials

From Amazon:
- Among the many suppliers (which will work fine) this one is a good starting point [Rasberry Pi 3 ($35+)](http://www.amazon.com/CanaKit-Raspberry-Complete-Starter-Kit/dp/B01C6Q2GSY/ref=sr_1_1_sspa?ie=UTF8&qid=1511712539&sr=8-1-spons&keywords=raspberry+pi+3&psc=1), and remember that keyboard, mouse, and HDMI capable computer monitor will also be required. Some Pi kits (around $80) come with an additional small keyboard and mouse combo.
- [Skrew terminal breakout block](http://www.amazon.com/dp/B01M27459S/ref=sxbs_sxwds-stvp_1?pf_rd_m=ATVPDKIKX0DER&pf_rd_p=3341940462&pd_rd_wg=o9P8Y&pf_rd_r=FZ2DCVEDSQ6NJ0X32N33&pf_rd_s=desktop-sx-bottom-slot&pf_rd_t=301&pd_rd_i=B01M27459S&pd_rd_w=NOabk&pf_rd_i=raspberry+pi+3+gpio+connector&pd_rd_r=bc208bc5-0b16-42f5-b047-39db7fbad512&ie=UTF8&qid=1511712653&sr=1) to connect the thermometers to the Pi's General Purpose Input and Output (GPIO).
- [DS18B20 Waterproof digital thermometer 5 pack](http://www.amazon.com/Ds18b20-18b20-Thermometer-Temperature-Sensor/dp/B00OZGWWQA/ref=sr_1_4?s=industrial&ie=UTF8&qid=1511713027&sr=1-4&keywords=18B20+thermometer).

The keyboard, mouse, and monitor are only required for setup or debugging the Pi. The idea of this package is allow access to the data through web page hosted by the Pi. You can also access the Pi and data through remote terminals such as `ssh`, using your laptop to change and modify code on the Pi. Chances are you will be running Linux (Raspbian / Ubuntu) on the Pi itself.

## Warnings

- The large (optional) **heatsink** on the Pi's CPU is **too big** when trying to attach the skrew terminal block on top of the board. You can skip installation of the big heatsink when working in cooler environments with lower CPU load, or cut the bigger heatsink smaller before installing it. Alternatively, please file an issue with this repo if you find a smaller heatsink for purchase which can be reported here. Yes, you can add the shortend heatsink later.
- **Change the username, password, and computer name** of the Raspberry Pi (after following the preinstalled---on the MicroSD card---Pi setup procedures). If the Pi is exposed to the Internet, the standard computer name, username and no password (same default for everybody) is vulnerable to hackers. Hacker-bots **will** come and install malware or spamware on the Pi, or use it as a weakpoint (trojan) behind your local firewall, which in turn can access your network. Simply changing the username, password, and computer name will make the Pi as resilient as any other computer on your network. Remember, the smart hackers won't let you discover they are doing something dodgy, so change the values now.

# Installation

Install Raspbian operating system by following the install prompts that come standard with MicroSD in the Raspberry Pi box. Remember to setup the WiFi or Ethernet cable connection before letting the install run. This will ensure you get the latest versions of Aptitude packages (`apt-get`) as part of the standard install.

**Change the username, password, and computer name**.

## After Raspbian is installed

After setting up the Pi and changing the password, install Julia by opening a terminal and typing:
```bash
sudo apt-get update
sudo apt-get install julia
julia
```

After julia is installed, you should be able to run a REPL with the command `julia`. Once in the Julia REPL, installation of this `Tempberry` package is done by:
```julia
julia> Pkg.clone("https://github.com/aviks/SMTPClient.jl.git")
julia> Pkg.clone("https://github.com/dehann/Tempberry.jl.git")
```

## Configuring the Pi

The `1-wire` interface (as well as `ssh`) must be activated, which can be done by clicking on the raspberry button on the top left of the screen  ->  `Preferences`  ->  `Raspberry Pi Configuration`, and navigating to the 'Interfaces' tab. Enable the `SSH` and `1-wire` options and click `OK`.

## Physical Thermometer Hardware Setup

Follow the [Adafruit blog](http://learn.adafruit.com/adafruits-raspberry-pi-lesson-11-ds18b20-temperature-sensing/parts) to connect one, two, ..., up to five `DS18B20` thermometers to the [skrew terminal breakout board](http://www.amazon.com/dp/B01M27459S/ref=sxbs_sxwds-stvp_1?pf_rd_m=ATVPDKIKX0DER&pf_rd_p=3341940462&pd_rd_wg=o9P8Y&pf_rd_r=FZ2DCVEDSQ6NJ0X32N33&pf_rd_s=desktop-sx-bottom-slot&pf_rd_t=301&pd_rd_i=B01M27459S&pd_rd_w=NOabk&pf_rd_i=raspberry+pi+3+gpio+connector&pd_rd_r=bc208bc5-0b16-42f5-b047-39db7fbad512&ie=UTF8&qid=1511712653&sr=1). Some soldering will be required. The connections are made to the `3.3V`, `GND`, and `IO4` pins of the GPIO connector.

# Usage

Work in progress
```
LD_LIBRARY_PATH=/usr/lib/arm-linux-gnueabihf:/home/pi/software/julia-1.2.0/bin/../lib/julia julia -e "using Tempberry; hosttempberrylive()"
```
