loadthermometers() {
    sudo modprobe w1-gpio
    sudo modprobe w1-therm
}

therm1() {
    while [ 1 -eq 1 ]; do
        cat /sys/bus/w1/devices/28-000008e51c89/w1_slave
        sleep 1
    done
}

therm2() {
    while [ 1 -eq 1 ]; do
        cat /sys/bus/w1/devices/28-000008e8632b/w1_slave
        sleep 1
    done
}
