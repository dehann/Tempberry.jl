
"""
    lstherm()

List thermometers currently connected and discoverable through `/sys/bus/w1/devices/28-*`
"""
function lstherm(;path="/sys/bus/w1/devices/")
  keeplist = String[]
  here=pwd()
  try
    cd(path)
    println("Reading $(path) for 28-* therm devices")
    dirfiles = readdir()
    for fin in dirfiles
      if fin[1:3] == "28-"
        push!(keeplist, fin)
      end
    end
  catch e
    warn("Unable to list any DS18B20 thermometers on the 1-wire interface.")
    warn(e)
  end
  cd(here)
  keeplist
end

function readtherm(thermname; path="/sys/bus/w1/devices")
  fid = open(joinpath(path,thermname,"w1_slave"),"r")
  l1 = readline(fid)
  l2 = readline(fid)
  close(fid)
  l2s = split(l2,'=')
  parse(Float64, l2s[2])/1000.0
end
