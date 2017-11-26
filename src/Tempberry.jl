module Tempberry

using HttpServer

export
  lstherm,
  readtherm,
  #gentemppage,
  hosttempswebpage,
  hostwebpage


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

function readtherm(thermname; path="/sys/bus/w1/devices")
  fid = open(joinpath(path,thermname,"w1_slave"),"r")
  l1 = readline(fid)
  l2 = readline(fid)
  close(fid)
  l2s = split(l2,'=')
  parse(Float64, l2s[2])/1000.0
end

#function gentempspage()
#  htmlstr = ""
#
#  return htmlstr
#end


function defaultpage(req, res)
    if ismatch(r"^/hello/",req.resource)
        string("Hello ", split(req.resource,'/')[3], "!")
    else
        404
    end
  end


function hostwebpage(;port=8000)
  http = HttpHandler() do req::Request, res::Response

      Response(  defaultpage(req, res)  )

  end
  server = Server( http )
  run(server, port=port)
  nothing
end

function gentemppage(req, res, temp1, temp2)
    if ismatch(r"^/hello/", req.resource)
        return "temp1=$(temp1), temp2=$(temp2)!"
    else
        return 404
    end
end

function hosttempswebpage(;port=8000)
  @show therms = lstherm()

  http = HttpHandler() do req::Request, res::Response
      temp1 = readtherm(therms[1])
      temp2 = readtherm(therms[2])
      Response(  gentemppage(req, res, temp1, temp2)  )
  end
  server = Server( http )
  run(server, port=port)
  nothing
end


end
