module Tempberry

using HttpServer

export
  lstherm


"""
    lstherm()

List thermometers currently connected and discoverable through `/sys/bus/w1/devices/28-*`
"""
function lstherm()
  here=pwd()
  path = "/sys/bus/w1/devices/"
  cd(path)
  println("Reading $(path) for 28-* therm devices")
  dirfiles = readdir()
  keeplist = String[]
  for fin in dirfiles
    if fin[1:3] == "28-"
      push!(keeplist, fin)
    end
  end
  cd(here)
  keeplist
end



end
