module Tempberry

using HttpServer

export
  lstherm


"""
    lstherm()

List thermometers currently connected and discoverable through `/sys/bus/w1/devices/28-*`
"""
function lstherm()
  run(`ls /sys/bus/w1/devices/28-*`)
end



end
